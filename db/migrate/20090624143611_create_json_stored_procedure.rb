class CreateJsonStoredProcedure < ActiveRecord::Migration
  def self.up
    List.connection.raw_connection.query(%(DROP FUNCTION IF EXISTS `JSON_FAST`))
    List.connection.raw_connection.query(%(
      CREATE FUNCTION JSON_FAST(`json` TEXT, `search_key` VARCHAR(255)) RETURNS TEXT DETERMINISTIC BEGIN
        IF INSTR(json, CONCAT('"', search_key, '":"')) THEN
          RETURN SUBSTRING_INDEX(SUBSTRING(json, INSTR(json, CONCAT('"', search_key, '":"')) +
                 LENGTH(search_key) + 4), '"', 1);
        ELSEIF INSTR(json, CONCAT('"', search_key, '": "')) THEN
          RETURN SUBSTRING_INDEX(SUBSTRING(json, INSTR(json, CONCAT('"', search_key, '": "')) +
                 LENGTH(search_key) + 5), '"', 1);
        ELSE
          RETURN NULL;
        END IF;
      END
    ))
  end

  def self.down
    List.connection.raw_connection.query(%(DROP FUNCTION IF EXISTS `JSON_FAST`))
  end
end
