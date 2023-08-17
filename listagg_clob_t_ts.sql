create or replace type listagg_clob_t as object
( t_varchar2 varchar2(32767)
, t_delim varchar2(255)
, t_clob clob
, static function odciaggregateinitialize( sctx in out listagg_clob_t
                                         , delim in varchar2 default ',' )
  return number
, member function odciaggregateiterate
    ( self in out listagg_clob_t
    , a_val varchar2
    )
  return number
, member function odciaggregateterminate
    ( self in out listagg_clob_t
    , returnvalue out clob
    , flags in number
    )
  return number
, member function odciaggregatemerge
    ( self in out listagg_clob_t
    , ctx2 in out listagg_clob_t
    )
  return number
)
/
