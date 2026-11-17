# frozen_string_literal: true

# Standard-2X is now the smallest size a pipeline can scale to. Raise base
# sizes below it to Standard-2X, and boost sizes at or below it to
# Performance-M, the smallest boost size. Review apps carry copies of both.
class RaiseDynoSizesToStandard2x < ActiveRecord::Migration[7.0]
  STANDARD_2X = 4
  PERFORMANCE_M = 5

  def up
    %w[pipelines review_apps].each do |table|
      execute "UPDATE #{table} SET base_size_id = #{STANDARD_2X} WHERE base_size_id < #{STANDARD_2X}"
      execute "UPDATE #{table} SET boost_size_id = #{PERFORMANCE_M} WHERE boost_size_id < #{PERFORMANCE_M}"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
