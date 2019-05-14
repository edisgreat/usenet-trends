ActiveAdmin.register AdminString do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params :cookie, :authstring, :status

  form do |f|
    f.inputs 'Details' do
      f.input :cookie
      f.input :authstring
      f.input :status
    end

    actions
  end
  
  index do
    selectable_column
    id_column
    column :cookie
    column :authstring
    column :status

    actions
  end

  filter :id
  filter :cookie
  filter :authstring
  filter :status

  show do
    attributes_table do
      row :id
      row :cookie
      row :authstring
      row :status
    end
  end
end
