create or replace type body listagg_clob_t
is
  static function odciaggregateinitialize( sctx in out listagg_clob_t, delim varchar2 default ',')
  return number
  is
  begin
    sctx := listagg_clob_t( null, null, delim, nvl(lengthb(delim), 0) );
    return odciconst.success;
  end;
--
  member function odciaggregateiterate
    ( self in out listagg_clob_t
    , a_val varchar2
    )
  return number
  is
    procedure add_val( p_val varchar2 )
    is
    begin
      if nvl( lengthb( self.t_varchar2 ), 0 ) + self.t_delim_len + nvl(lengthb( p_val ), 0) <= 4000
-- Strange limit, the max size of self.t_varchar2 is 29993
-- If you exceeds this number you get ORA-22813: operand value exceeds system limits
-- with 29993 you get JSON-output as large 58894 bytes
-- with 4000 you get JSON-output as large 1063896 bytes, probably max more
      then
        self.t_varchar2 := self.t_varchar2 || self.t_delim || p_val;
      else
        if self.t_clob is null
        then
          dbms_lob.createtemporary( self.t_clob, true, dbms_lob.call );
        end if;
        dbms_lob.writeappend( self.t_clob, length( self.t_varchar2 ), self.t_varchar2 );
        self.t_varchar2 := self.t_delim || p_val;
      end if;
    end;
  begin
    add_val( a_val );
    return odciconst.success;
  end;
--
  member function odciaggregateterminate
    ( self in out listagg_clob_t
    , returnvalue out clob
    , flags in number
    )
  return number
  is
  begin
    if self.t_clob is null
    then
      dbms_lob.createtemporary( self.t_clob, true, dbms_lob.call );
    end if;
    if self.t_varchar2 is not null
    then
      dbms_lob.writeappend( self.t_clob, length( self.t_varchar2 ), self.t_varchar2);
    end if;
    returnvalue := substr(self.t_clob, 1 + nvl(length(self.t_delim), 0));
    return odciconst.success;
  end;
--
  member function odciaggregatemerge
    ( self in out listagg_clob_t
    , ctx2 in out listagg_clob_t
    )
  return number
  is
  begin
    if self.t_clob is null
    then
      dbms_lob.createtemporary( self.t_clob, true, dbms_lob.call );
    end if;
    if self.t_varchar2 is not null
    then
      dbms_lob.writeappend( self.t_clob, length( self.t_varchar2 ), self.t_varchar2 );
    end if;
    if ctx2.t_clob is not null
    then
      dbms_lob.append( self.t_clob, ctx2.t_clob );
      dbms_lob.freetemporary( ctx2.t_clob );
    end if;
    if ctx2.t_varchar2 is not null
    then
      dbms_lob.writeappend( self.t_clob, length( ctx2.t_varchar2 ), ctx2.t_varchar2 );
      ctx2.t_varchar2 := null;
    end if;
    return odciconst.success;
  end;

  member function odciaggregatedelete
    ( self in out listagg_clob_t
    , a_val varchar2
    )
  return number
  is
  begin
    self.t_varchar2 := '';
    if self.t_clob is not null
    then
      dbms_lob.trim(self.t_clob, 0);
    end if;
    return odciconst.success;
  end;
  
--
end;
/
