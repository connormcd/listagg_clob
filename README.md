# listagg_clob
extends listagg beyond its varchar2 limits

"Standard" LISTAGG takes *varchar2* and returns a concatenation that may be longer than the limit of *varchar2* which can be problematic.  LISTAGG_CLOB takes *varchar2* inputs and returns a clob to workaround the limitation of the *output* length. Concatenated *varchar2* are separated by a comma character.


## Installation Guide

```console
@@listagg_clob_t_ts.sql
@@listagg_clob_t_tb.sql
@@listagg_clob.sql
```

## Sample Usage

```console
select length(listagg_clob(str)), listagg_clob(str) from (
  select lpad('a', 4000, 'a') as str from dual
);

select length(listagg_clob(str)), listagg_clob(str) from (
  select lpad('a', 5, 'a') as str from dual
  union all
  select lpad('b', 10, 'b') as str from dual
);

select length(listagg_clob(str)), listagg_clob(str) from (
  select lpad('a', 4000, 'a') as str from dual
  union all
  select lpad('b', 4000, 'b') as str from dual
);

select length(listagg_clob(str)), listagg_clob(str) from (
  select lpad('a', 2, 'a') as str from dual
  union all
  select lpad('b', 3, 'b') as str from dual
  union all
  select lpad('c', 4, 'c') as str from dual
);

select length(listagg_clob(str)), listagg_clob(str) from (
  select lpad('a', 3, 'a') as str from dual
  union all
  select lpad('b', 4, 'b') as str from dual
  union all
  select null as str from dual
  union all
  select lpad('c', 4000, 'c') as str from dual
);
```

## Usual stuff

This software comes WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

Acknowledgements to the ground laying work by Anton Scheffer, via
https://technology.amis.nl/2015/03/13/using-an-aggregation-function-to-query-a-json-string-straight-from-sql/
