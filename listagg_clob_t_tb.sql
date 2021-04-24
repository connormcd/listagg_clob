create or replace type body listagg_clob_t
is
  static function odciaggregateinitialize( sctx in out listagg_clob_t )
  return number
  is
  begin
    sctx := listagg_clob_t( null, null, 0 );
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
      if self.t_length + lengthb( p_val ) < 4000 then
        if self.t_varchar2 is null then
          self.t_varchar2 := p_val;
        else
          self.t_varchar2 := self.t_varchar2 || ',' || p_val;
        end if;
      else
        -- Concatenated string too long to fit into a VARCHAR2
        if self.t_clob is null then
          dbms_lob.createtemporary( self.t_clob, true, dbms_lob.call );
          if self.t_varchar2 is not null then
            dbms_lob.writeappend( self.t_clob, length( self.t_varchar2 ), self.t_varchar2 );
            dbms_lob.writeappend( self.t_clob, 1, ',' );
          end if;
          self.t_varchar2 := null;
        else  -- self.t_clob is not null
            dbms_lob.writeappend( self.t_clob, 1, ',' );
        end if;
        dbms_lob.writeappend( self.t_clob, length( p_val ), p_val );
      end if;
      self.t_length := self.t_length + 1 + lengthb( p_val );  -- separator adds 1 byte
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
      dbms_lob.writeappend( self.t_clob, length( self.t_varchar2 ), self.t_varchar2 );
    end if;
    returnvalue := self.t_clob;
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
    if self.t_length + ctx2.t_length < 4000 then
      if ctx2.t_varchar2 is not null then
        self.t_varchar2 := self.t_varchar2 || ',' || ctx2.t_varchar2;
        ctx2.t_varchar2 := null;
      end if;
    else
      -- Concatenated string too long to fit into a VARCHAR2
      if self.t_clob is null then
        dbms_lob.createtemporary( self.t_clob, true, dbms_lob.call );
        if self.t_varchar2 is not null then
          dbms_lob.writeappend( self.t_clob, length( self.t_varchar2 ), self.t_varchar2 );
        end if;
        self.t_varchar2 := null;
      end if;
      if ctx2.t_clob is not null then
        dbms_lob.writeappend( self.t_clob, 1, ',' );
        dbms_lob.append( self.t_clob, ctx2.t_clob );
        dbms_lob.freetemporary( ctx2.t_clob );
      end if;
      if ctx2.t_varchar2 is not null then
        dbms_lob.writeappend( self.t_clob, 1, ',' );
        dbms_lob.writeappend( self.t_clob, length( ctx2.t_varchar2 ), ctx2.t_varchar2 );
        ctx2.t_varchar2 := null;
      end if;
    end if;
    self.t_length := self.t_length + 1 + ctx2.t_length;  -- separator adds 1 byte
    return odciconst.success;
  end;
--
end;
/
show error
