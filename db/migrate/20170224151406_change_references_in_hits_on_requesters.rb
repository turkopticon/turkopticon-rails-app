class ChangeReferencesInHitsOnRequesters < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :hits, column: :requester_id

    change_column :requesters, :rid, :string, limit: 30, null: false
    change_column :hits, :requester_id, :string, limit: 30

    execute <<-SQL
UPDATE hits SET requester_id = requesters.rid FROM requesters WHERE requesters.id = hits.requester_id::INTEGER;
ALTER TABLE requesters DROP COLUMN id;
DROP INDEX public_requesters_rid0_idx;
CREATE UNIQUE INDEX requesters_pkey ON requesters USING BTREE (rid);
ALTER TABLE hits ADD CONSTRAINT hits_requester_id_fkey FOREIGN KEY (requester_id) REFERENCES requesters (rid);
    SQL

    # remove_column :requesters, :id
    # remove_index :requesters, :rid
    # add_index :requesters, :rid, unique: true, name: :requesters_pkey
  end
end
