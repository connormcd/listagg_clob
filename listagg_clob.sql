create or replace function listagg_clob (agg varchar2, delim varchar2 default ',')
return clob
parallel_enable aggregate using listagg_clob_t;
/

--
-- Sample usage
--
-- select listagg_clob(ename,',') from scott.emp;
-- select listagg_clob(ename) from scott.emp;
-- select listagg_clob(ename,'') from scott.emp;
--