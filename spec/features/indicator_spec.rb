require 'rails_helper'

RSpec.feature 'Indicators', type: :feature do
  include FeatureSpecHelpers
  let!(:indicators) { FactoryGirl.create_list(:indicator, 5) }
  let(:indicator) { FactoryGirl.create(:indicator) }
  let(:our_user) { false }
  before { login_as(our_user) if our_user }

  shared_examples 'not_authorized' do
    it { expect(page).to have_content('You are not authorized to perform this action') }
  end
  shared_examples 'need_to_sign_in' do
    it { expect(page).to have_content('You need to sign in or sign up before continuing') }
  end

  describe 'index page' do
    before { visit indicators_path }
    def expect_index_page
      expect(page).to have_content('Indicators')
      expect(page).to have_content(indicators.first.title)
    end

    context 'when logged in as admin' do
      let(:our_user) { admin_user }
      it { expect_index_page }
      it { expect(page).to have_content('New') }
    end
    context 'when logged in as manager' do
      let(:our_user) { manager_user }
      it { expect_index_page }
      it { expect(page).to have_content('New') }
    end

    context 'when logged in as reporter' do
      let(:our_user) { reporter_user }
      it { expect_index_page }
      it { expect(page).to have_link('New', href: new_indicator_path) }
    end

    context 'when logged in but has no roles' do
      let(:our_user) { user }
      it { expect(page).not_to have_link('New', href: new_indicator_path) }
    end

    context 'anonymous' do
      it { expect(page).not_to have_link('New', href: new_indicator_path) }
      it { expect(page).not_to have_content('Indicators') }
      it { expect(page).not_to have_content(indicators.first.title) }
      it { expect(page).not_to have_link('New', href: new_indicator_path) }
      include_examples 'need_to_sign_in'
    end
  end

  describe 'show' do
    before { visit indicator_path(indicators.first) }
    shared_examples 'show_page' do
      it { expect(page).to have_content('Indicators') }
      it { expect(page).to have_content(indicators.first.title) }
      it { expect(page).to have_content(indicators.first.description) }
    end
    shared_examples 'edit_link' do
      it { expect(page).to have_link('Edit', href: edit_indicator_path(indicators.first)) }
    end
    context 'when logged in as admin' do
      let(:our_user) { admin_user }
      include_examples 'show_page'
      include_examples 'edit_link'
    end
    context 'when logged in as manager' do
      let(:our_user) { manager_user }
      include_examples 'show_page'
      include_examples 'edit_link'
    end

    context 'when logged in as reporter' do
      let(:our_user) { reporter_user }
      include_examples 'show_page'
      include_examples 'edit_link'
    end

    context 'when logged in but has no roles' do
      let(:our_user) { user }
      include_examples 'show_page'
      it { expect(page).not_to have_link('Edit', href: edit_indicator_path(indicators.first)) }
    end

    context 'anonymous' do
      it { expect(page).not_to have_content('Indicators') }
      it { expect(page).not_to have_content(indicators.first.title) }
      it { expect(page).not_to have_content(indicators.first.description) }
      it { expect(page).not_to have_link('Edit', href: edit_indicator_path(indicators.first)) }
      include_examples 'need_to_sign_in'
    end
  end

  describe 'new' do
    shared_examples 'new_page' do
      it { expect(page).to have_content('Indicator') }
      it { expect(page).to have_button('Save') }
      it { expect(page).to have_content('Cancel') }
    end
    before { visit edit_indicator_path(indicator) }
    context 'when logged in as admin' do
      let(:our_user) { admin_user }
      include_examples 'new_page'
    end
    context 'when logged in as manager' do
      let(:our_user) { manager_user }
      include_examples 'new_page'
    end

    context 'when logged in as reporter' do
      let(:our_user) { reporter_user }
      include_examples 'new_page'
    end

    context 'when logged in but has no roles' do
      let(:our_user) { user }
      include_examples 'not_authorized'
    end

    context 'anonymous' do
      include_examples 'need_to_sign_in'
    end
  end

  describe 'create' do
    before do
      visit new_indicator_path
      fill_in 'Title', with: 'title of awesome'
      click_button 'Save'
    end
    shared_examples 'indicator_created' do
      it { expect(Indicator.last.title).to eq 'title of awesome' }
      it { expect(page).to have_content(I18n.t('notice.indicator.create.success')) }
    end
    context 'when logged in as admin' do
      let(:our_user) { admin_user }
      include_examples 'indicator_created'
    end
    context 'when logged in as manager' do
      let(:our_user) { manager_user }
      include_examples 'indicator_created'
    end
    context 'when logged in as reporter' do
      let(:our_user) { reporter_user }
      include_examples 'indicator_created'
    end
    pending 'when logged in but has no roles' do
      let(:our_user) { user }
      include_examples 'not_authorized'
    end
    pending 'anonymous' do
      include_examples 'need_to_sign_in'
    end
  end

  describe 'edit' do
    before { visit edit_indicator_path(indicator) }
    shared_examples 'edit_page' do
      it { expect(page).to have_content('Indicators') }
      it { expect(find_field('Title').value).to eq(indicator.title) }
      it { expect(find_field('Description').value).to eq(indicator.description) }
      it { expect(page).to have_button('Save') }
      it { expect(page).to have_link('Cancel') }
    end
    context 'when logged in as admin' do
      let(:our_user) { admin_user }
      include_examples 'edit_page'
    end
    context 'when logged in as manager' do
      let(:our_user) { manager_user }
      include_examples 'edit_page'
    end
    context 'when logged in as reporter' do
      let(:our_user) { reporter_user }
      include_examples 'edit_page'
    end
    context 'when logged in but has no roles' do
      let(:our_user) { user }
      include_examples 'not_authorized'
    end
    context 'anonymous' do
      include_examples 'need_to_sign_in'
    end
  end

  describe 'update' do
    before do
      visit edit_indicator_path(indicator)
      fill_in 'Title', with: 'new awesome title'
      click_button 'Save'
    end
    shared_examples 'update_saves' do
      it do
        indicator.reload
        expect(indicator.title).to eq('new awesome title')
      end
      it { expect(page).to have_content(I18n.t('notice.indicator.update.success')) }
    end
    context 'when logged in as admin' do
      let(:our_user) { admin_user }
      include_examples 'update_saves'
    end
    context 'when logged in as manager' do
      let(:our_user) { manager_user }
      include_examples 'update_saves'
    end
    context 'when logged in as reporter' do
      let(:our_user) { reporter_user }
      include_examples 'update_saves'
    end
    pending 'when logged in but has no roles' do
      let(:our_user) { user }
      include_examples 'not_authorized'
    end
    pending 'anonymous' do
      include_examples 'need_to_sign_in'
    end
  end
end
