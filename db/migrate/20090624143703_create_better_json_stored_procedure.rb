class CreateBetterJsonStoredProcedure < ActiveRecord::Migration
  def self.up
    List.connection.raw_connection.query(%(DROP FUNCTION IF EXISTS `JSON`))
    List.connection.raw_connection.query(%(
    CREATE FUNCTION JSON(`json` TEXT, `search_key` VARCHAR(255)) RETURNS TEXT DETERMINISTIC BEGIN

      DECLARE i INT DEFAULT 1;
      DECLARE json_length INT DEFAULT LENGTH(json);
      DECLARE state ENUM('reading_key','done_reading_key','reading_string', 'reading_array');
      DECLARE tmp_key TEXT;
      DECLARE tmp_value TEXT;
      DECLARE current_char VARCHAR(1);

      WHILE i <= json_length DO
        SET current_char = SUBSTRING(json,i,1);

        IF state = 'reading_key' THEN
          IF current_char = '"' THEN
            SET state = 'done_reading_key';
          ELSE
            SET tmp_key = CONCAT(tmp_key, current_char);
          END IF;
        ELSEIF state = 'done_reading_key' THEN
          IF current_char = '"' THEN
            SET state = 'reading_string';
          ELSEIF current_char = '[' THEN
            SET state = 'reading_array';
          END IF;
        ELSEIF (state = 'reading_string') OR (state = 'reading_array') THEN
          IF current_char = '\' THEN
            SET i = i + 1;
            SET tmp_value = CONCAT(tmp_value, SUBSTRING(json,i,1));
          ELSEIF (state = 'reading_string' AND current_char = '"') OR (state = 'reading_array' AND current_char = ']') THEN
            IF search_key = tmp_key THEN
              RETURN tmp_value;
            ELSE
              SET state = NULL;
            END IF;
          ELSE
            SET tmp_value = CONCAT(tmp_value, current_char);
          END IF;
        ELSE
          IF current_char='"' THEN
            SET state = 'reading_key';
            SET tmp_key = '';
            SET tmp_value = '';
          END IF;
        END IF;

        SET i = i + 1;
      END WHILE;

      RETURN NULL;
    END
    ))
  end

  def self.down
  end
end
