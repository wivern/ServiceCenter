class ResetSequence < ActiveRecord::Migration
  def self.up
    execute <<-SQL
    CREATE LANGUAGE 'plpgsql';
CREATE OR REPLACE FUNCTION "reset_sequence" (tablename text,columnname text) RETURNS bigint --"pg_catalog"."void"
AS
$body$
  DECLARE seqname character varying;
          c integer;
  BEGIN
    select tablename || '_' || columnname || '_seq' into seqname;
    EXECUTE 'SELECT max("' || columnname || '") FROM "' || tablename || '"' into c;
    if c is null then c = 0; end if;
    c = c+1; --because of substitution of setval with "alter sequence"
    --EXECUTE 'SELECT setval( "' || seqname || '", ' || cast(c as character varying) || ', false)'; DOES NOT WORK!!!
    EXECUTE 'alter sequence ' || seqname ||' restart with ' || cast(c as character varying);
    RETURN nextval(seqname)-1;
  END;
$body$ LANGUAGE 'plpgsql';
    SQL
  end

  def self.down
    execute <<-SQL
      DROP FUNCTION "reset_sequence";
      DROP LANGUAGE 'plpgsql';
    SQL
  end
end
