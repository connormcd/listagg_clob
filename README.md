# listagg_clob
extends listagg beyond its varchar2 limits


## Installation Guide

```console
@@listagg_clob_t_ts.sql
@@listagg_clob_t_tb.sql
@@listagg_clob.sql
```

## Sample Usage

```console
SQL> select listagg_clob(owner)
  2  from dba_objects
  3  where rownum <= 10;

LISTAGG_CLOB(OWNER)
-----------------------------------------------
SYS,SYS,SYS,SYS,SYS,SYS,SYS,SYS,SYS,SYS

1 row selected.
```

## Usual stuff

This software comes WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.