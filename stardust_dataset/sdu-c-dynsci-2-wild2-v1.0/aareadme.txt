
The Stardust Wild 2 Encounter Dynamic Science Experiment Data Archive
========================================================================


Introduction
============

   This document provides an overview of this volume of the Stardust
   Wild 2 Encounter Dynamic Science Experiment Data Archive, including
   a complete listing of the volume contents.

   This volume contains Dynamic Science Experiment data. Refer to the
   PDS DATASET catalog objects for more details.
      

Volume Format
=============

   This volume has been formatted according to the ISO-9660 level 2
   Interchange Standard.

   This volume does not contain any Extended Attribute Records (XAR).
   Thus, some VAX/VMS users may have problems accessing files on this
   volume.


File Formats
============

   All text documents and other meta information files such as
   descriptions, PDS object definitions and detached PDS labels are
   stream format files, with a carriage return (ASCII 13) and a line
   feed character (ASCII 10) at the end of the record.  This allows the
   files to be read by MS-DOS/Windows, Unix, and VMS operating systems.
   

Volume Contents
===============

   Files on this volume are organized into a set of subdirectories
   below the top-level directory. The following table shows the
   structure and content of these directories. In the table, directory
   names are enclosed in square brackets ([]). See the *INFO.TXT files
   in each directory for specific information on the files in the
   directory.

   [TOP-LEVEL-DIRECTORY]
   |
   |-- AAREADME.TXT        The text version of the AAREADME file.
   |-- AAREADME.LBL        PDS label for both AAREADME files.
   |-- VOLDESC.CAT         Description of the contents of this volume.
   |-- ERRATA.TXT          Comments and errata on this volume.
   |
   |--[CATALOG]            Directory containing PDS catalog objects.
   |  |
   |  |-- CATINFO.TXT            Description of files in the CATALOG directory.
   |  |-- DATASET.CAT            Description of Wild 2 Dynamic Science data set.
   |  |-- DYNSCI.CAT             Description of the Dynamic Science instruments.
   |  |-- SDU.CAT                Description of the Stardust spacecraft.
   |  |-- STARDUST.CAT           Description of the Stardust mission.
   |  |-- PERSONNEL.CAT          Description of personnel who created this volume.
   |  |-- REFERENCE.CAT          List of publications mentioned in catalog files.
   |  +-- 81P_WILD_2_1978_A2.CAT Description of the mission target, comet Wild 2.
   |
   |--[DATA]               Directory containing Dynamic Science data files.
   |  |
   |  |-- *.TAB            Dynamic Science Experiment data file(s).
   |  |-- *.LBL            Label(s) for Dynamic Science data file(s).
   |  +-- *.FMT            Dynamic Science table format definition file(s).
   |
   |--[DOCUMENT]           Directory containing volume related documents.
   |  |
   |  |-- DOCINFO.TXT      Description of files in the DOCUMENT directory.
   |  |-- SFF_SIS_SDU.PDF  Small Forces File SIS in Adobe PDF format.
   |  |-- SFF_SIS_SDU.LBL  Label for Small Forces File SIS.
   |  +-- ONLABELS.TXT     Description of PDS labels for data files.
   |
   +--[INDEX]              Directory containing index files.
      |
      |-- INDXINFO.TXT     Description of files in the INDEX directory.
      |-- INDEX.TAB        Index table of Dynamic Science data on this volume.
      +-- INDEX.LBL        PDS label for INDEX.TAB file.


Whom to Contact for Information
===============================

   Stardust Radio Science and Dynamic Science Experiment Science Lead:

      Dr. John D. Anderson
      Phone: +1 (818) 354-3956
      Electronic mail address: John.D.Anderson@jpl.nasa.gov

      MAIL STOP 238-420
      Jet Propulsion Laboratory
      California Institute of Technology
      4800 Oak Grove Drive
      Pasadena, CA, 91109-8099

   Stardust Data Management and Archive Team (DMA):

      Charles H. Acton, Jr.
      Phone: +1 (818) 354-3869
      Electronic mail address: Charles.Acton@jpl.nasa.gov

      Boris V. Semenov
      Phone: +1 (818) 354-8136
      Electronic mail address: Boris.Semenov@jpl.nasa.gov

      MAIL STOP 301-125L
      Jet Propulsion Laboratory
      California Institute of Technology
      4800 Oak Grove Drive
      Pasadena, CA, 91109-8099


Cognizant Persons
=================

   The volume was designed Stardust DMA team (Charles Acton and Boris
   Semenov.)
 
