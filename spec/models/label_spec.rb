# == Schema Information
#
# Table name: labels
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Label, type: :model do

  describe "アソシエーション" do

    describe "has_many task_label" do

      let!(:label) { create(:label) }
      let!(:task_labels) { create_pair(:task_label, label: label) }

      it "LabelとTaskLabelは1対多の関係になる" do
        expect(label.task_labels).to match_array task_labels
      end

      context "ラベルーを削除した時" do

        it "関連するタスクラベルが削除される" do
          expect{ label.destroy }.to change{ TaskLabel.count }.by(-2)
        end

      end

    end

  end

end
