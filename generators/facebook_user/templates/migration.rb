class <%=migration_name%> < ActiveRecord::Migration
  def self.up
    create_table "<%=table_name%>", :force => true do |t|
      t.integer :facebook_id,:limit=>20
      t.string :session_key
      t.timestamps
    end
    add_index "<%=table_name%>", :facebook_id,:unique=>true
  end

  def self.down
    remove_index "<%=table_name%>", :facebook_id
    drop_table :facebook_templates
  end
end
