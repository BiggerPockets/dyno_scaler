# frozen_string_literal: true

require 'rails_helper'

describe 'Manager edits a pipeline' do
  it 'persists the changes and display a flash success banner' do
    pipeline = create(
      :pipeline,
      name: 'My Pipeline',
      base_size: DynoSize.standard_2x,
      boost_size: DynoSize.performance_m,
      set_env: true
    )
    user = create(:user, :manager, organisation: pipeline.organisation)

    visit pipeline_path(pipeline, as: user)
    click_on 'Edit'

    select 'Performance-M', from: 'Base dyno type'
    select 'Performance-L', from: 'Boost dyno type'
    uncheck 'Set env variable'

    click_on 'Update Pipeline'
    expect(page).to have_text 'Pipeline was successfully updated'

    click_on 'Edit'
    expect(page).to have_select('Base dyno type', selected: 'Performance-M')
    expect(page).to have_select('Boost dyno type', selected: 'Performance-L')
    expect(page).to have_unchecked_field('Set env variable')
  end

  it 'disables editing of the uuid' do
    pipeline = create(
      :pipeline, name: 'My Pipeline', base_size: DynoSize.standard_2x, boost_size: DynoSize.performance_m
    )
    user = create(:user, :manager, organisation: pipeline.organisation)

    visit edit_pipeline_path(pipeline, as: user)

    expect(page).to have_field('UUID', disabled: true)
  end
end
