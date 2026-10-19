"""
Reader for the NASA/PDS Stardust Wild 2 Dynamic Science dataset.

Dataset:
    SDU-C-DYNSCI-2-WILD2-V1.0

This module intentionally keeps the PDS ingestion layer separate from the
simulation framework. The public API returns pandas DataFrames with explicit
column names and normalized timestamps/units.

Expected input:
    sdu-c-dynsci-2-wild2-v1.0 folder's path
    
Reference:
    https://pdssbn.astro.umd.edu/holdings/sdu-c-dynsci-2-wild2-v1.0/dataset.shtml
"""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Union
import io
import tarfile

import numpy as np
import pandas as pd


PathLike = Union[str, Path]

_ARCHIVE_ROOT = "sdu-c-dynsci-2-wild2-v1.0/data"

AACS_COLUMNS = [
    "UTC_TIME",
    "ACS_MODE",
    "ATT_QU_I2B_1",
    "ATT_QU_I2B_2",
    "ATT_QU_I2B_3",
    "ATT_QU_I2B_4",
    "ATT_RAT_BF_X",
    "ATT_RAT_BF_Y",
    "ATT_RAT_BF_Z",
    "ATT_ERR_BF_X",
    "ATT_ERR_BF_Y",
    "ATT_ERR_BF_Z",
    "RAT_ERR_BF_X",
    "RAT_ERR_BF_Y",
    "RAT_ERR_BF_Z",
]

SFF_COLUMNS = [
    "INDEX",
    "RECTYPE",
    "GENTIM",
    "STARTTIM",
    "STOPTIM",
    "DTIME",
    "DMASS",
    "DVX",
    "DVY",
    "DVZ",
    "AVG_ATT_QUAT_Q1",
    "AVG_ATT_QUAT_Q2",
    "AVG_ATT_QUAT_Q3",
    "AVG_ATT_QUAT_Q4",
    "RCS1_ACC_ON_CMDS",
    "RCS2_ACC_ON_CMDS",
    "RCS3_ACC_ON_CMDS",
    "RCS4_ACC_ON_CMDS",
    "RCS5_ACC_ON_CMDS",
    "RCS6_ACC_ON_CMDS",
    "RCS7_ACC_ON_CMDS",
    "RCS8_ACC_ON_CMDS",
    "TCM1_ACC_ON_CMDS",
    "TCM2_ACC_ON_CMDS",
    "TCM3_ACC_ON_CMDS",
    "TCM4_ACC_ON_CMDS",
    "TCM5_ACC_ON_CMDS",
    "TCM6_ACC_ON_CMDS",
    "TCM7_ACC_ON_CMDS",
    "TCM8_ACC_ON_CMDS",
    "RCS1_ACC_ON_TIME",
    "RCS2_ACC_ON_TIME",
    "RCS3_ACC_ON_TIME",
    "RCS4_ACC_ON_TIME",
    "RCS5_ACC_ON_TIME",
    "RCS6_ACC_ON_TIME",
    "RCS7_ACC_ON_TIME",
    "RCS8_ACC_ON_TIME",
    "TCM1_ACC_ON_TIME",
    "TCM2_ACC_ON_TIME",
    "TCM3_ACC_ON_TIME",
    "TCM4_ACC_ON_TIME",
    "TCM5_ACC_ON_TIME",
    "TCM6_ACC_ON_TIME",
    "TCM7_ACC_ON_TIME",
    "TCM8_ACC_ON_TIME",
    "DPSCLK",
    "BEGIN_TIME",
    "END_TIME",
]

AACS_NUMERIC = [
    "ATT_QU_I2B_1",
    "ATT_QU_I2B_2",
    "ATT_QU_I2B_3",
    "ATT_QU_I2B_4",
    "ATT_RAT_BF_X",
    "ATT_RAT_BF_Y",
    "ATT_RAT_BF_Z",
    "ATT_ERR_BF_X",
    "ATT_ERR_BF_Y",
    "ATT_ERR_BF_Z",
    "RAT_ERR_BF_X",
    "RAT_ERR_BF_Y",
    "RAT_ERR_BF_Z",
]

SFF_NUMERIC = [c for c in SFF_COLUMNS if c not in {
    "RECTYPE", "GENTIM", "STARTTIM", "STOPTIM", "BEGIN_TIME", "END_TIME"
}]

SFF_TIME_COLUMNS = ["GENTIM", "STARTTIM", "STOPTIM", "BEGIN_TIME", "END_TIME"]


@dataclass(frozen=True)
class StardustDataset:
    """Container for the two primary Stardust telemetry tables."""

    attitude: pd.DataFrame
    small_forces: pd.DataFrame

    @property
    def quaternion(self) -> np.ndarray:
        """Return AACS attitude quaternions as [qx, qy, qz, qw]."""
        return self.attitude[
            [
                "ATT_QU_I2B_1",
                "ATT_QU_I2B_2",
                "ATT_QU_I2B_3",
                "ATT_QU_I2B_4",
            ]
        ].to_numpy(dtype=float)

    @property
    def angular_rate(self) -> np.ndarray:
        """Return body angular rate in rad/s as [wx, wy, wz]."""
        return self.attitude[
            ["ATT_RAT_BF_X", "ATT_RAT_BF_Y", "ATT_RAT_BF_Z"]
        ].to_numpy(dtype=float)


class _DatasetArchive:
    """Small helper that reads files from either a .tgz archive or directory."""

    def __init__(self, source: PathLike):
        self.source = Path(source)
        self._tar: tarfile.TarFile | None = None

        if self.source.is_file():
            self._tar = tarfile.open(self.source, "r:gz")
        elif not self.source.is_dir():
            raise FileNotFoundError(f"Dataset source not found: {self.source}")

    def __enter__(self) -> "_DatasetArchive":
        return self

    def __exit__(self, exc_type, exc, tb) -> None:
        if self._tar is not None:
            self._tar.close()

    def read_bytes(self, filename: str) -> bytes:
        relative = f"{_ARCHIVE_ROOT}/{filename}"

        if self._tar is not None:
            # PDS archive paths are case-insensitive in practice, but use
            # the exact path from the Stardust archive first.
            try:
                member = self._tar.getmember(relative)
            except KeyError:
                matches = [
                    name for name in self._tar.getnames()
                    if name.lower() == relative.lower()
                ]
                if not matches:
                    raise FileNotFoundError(relative)
                member = self._tar.getmember(matches[0])

            stream = self._tar.extractfile(member)
            if stream is None:
                raise IOError(f"Could not extract {relative}")
            return stream.read()

        path = self.source / relative

        if not path.exists():
            raise FileNotFoundError(path)
        return path.read_bytes()


def _parse_time(series: pd.Series) -> pd.Series:
    return pd.to_datetime(series.astype(str).str.strip(), errors="raise")


def _validate_columns(df: pd.DataFrame, expected: list[str], name: str) -> None:
    if list(df.columns) != expected:
        raise ValueError(
            f"{name}: unexpected columns.\n"
            f"Expected: {expected}\n"
            f"Got:      {list(df.columns)}"
        )


def read_aacs_tlm(source: PathLike) -> pd.DataFrame:
    """
    Read SDU_W2_AACS_TLM.TAB.

    The first four records are the PDS CSV header. Data units:
        quaternion: dimensionless, [qx, qy, qz, qw]
        angular rate: rad/s
        attitude error: rad
        rate error: rad/s
    """
    with _DatasetArchive(source) as archive:
        raw = archive.read_bytes("sdu_w2_aacs_tlm.tab")

    # The PDS product itself provides a four-line CSV header.
    df = pd.read_csv(
        io.BytesIO(raw),
        skiprows=4,
        header=None,
        names=AACS_COLUMNS,
        skipinitialspace=True,
        quotechar='"',
    )

    _validate_columns(df, AACS_COLUMNS, "AACS telemetry")

    df["UTC_TIME"] = _parse_time(df["UTC_TIME"])

    for column in AACS_NUMERIC:
        df[column] = pd.to_numeric(df[column], errors="raise")

    # Explicit derived convenience columns.
    t0 = df["UTC_TIME"].iloc[0]
    df["TIME_S"] = (df["UTC_TIME"] - t0).dt.total_seconds()

    q = df[[
        "ATT_QU_I2B_1",
        "ATT_QU_I2B_2",
        "ATT_QU_I2B_3",
        "ATT_QU_I2B_4",
    ]].to_numpy(float)
    df["QUAT_NORM"] = np.linalg.norm(q, axis=1)

    return df


def read_sff(source: PathLike) -> pd.DataFrame:
    """
    Read SDU_W2_SFF.TAB (Small Forces File).

    Important:
        STARTTIM/STOPTIM and BEGIN_TIME/END_TIME describe the telemetry
        accumulation packet. They do NOT necessarily equal the individual
        physical firing times.

    Units:
        DTIME: seconds
        DMASS: kg
        DVX/DVY/DVZ: m/s
        accumulated on-time: milliseconds
        quaternion: [qx, qy, qz, qw]
    """
    with _DatasetArchive(source) as archive:
        raw = archive.read_bytes("sdu_w2_sff.tab")

    # The SFF file has a six-line text header ending in $$EOH.
    df = pd.read_csv(
        io.BytesIO(raw),
        skiprows=6,
        header=None,
        names=SFF_COLUMNS,
        skipinitialspace=True,
        quotechar='"',
    )

    _validate_columns(df, SFF_COLUMNS, "SFF")
    
    for column in SFF_TIME_COLUMNS:
        df[column] = _parse_time(df[column])

    for column in SFF_NUMERIC:
        df[column] = pd.to_numeric(df[column], errors="raise")

    df["TOTAL_RCS_FIRINGS"] = df[
        [f"RCS{i}_ACC_ON_CMDS" for i in range(1, 9)]
    ].sum(axis=1)

    df["TOTAL_TCM_FIRINGS"] = df[
        [f"TCM{i}_ACC_ON_CMDS" for i in range(1, 9)]
    ].sum(axis=1)

    return df


def load_stardust(source: PathLike) -> StardustDataset:
    """Load both primary Stardust tables."""
    return StardustDataset(
        attitude=read_aacs_tlm(source),
        small_forces=read_sff(source),
    )


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
        description="Read Stardust Wild 2 PDS dynamic science data."
    )
    parser.add_argument("dataset", help="Path to sdds_0001.tgz or extracted dataset directory")
    args = parser.parse_args()

    data = load_stardust(args.dataset)

    print(f"Attitude rows:     {len(data.attitude):,}")
    print(f"Small-forces rows: {len(data.small_forces):,}")
    print()
    print(data.attitude.head())
    print()
    print(data.small_forces.head())
