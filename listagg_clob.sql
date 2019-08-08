create or replace function listagg_clob( agg varchar2 )
return clob
parallel_enable aggregate using listagg_clob_t;
/

