ActiveAdmin.register Result do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params :start_date, :end_date, :query, :cookie, :author_email, :author_name, :status, :authstring

  form do |f|
    f.inputs 'Details' do
      f.input :start_date
      f.input :end_date
      f.input :amount
      f.input :precision
      f.input :status
      f.input :request_id
    end

    actions
  end
  
  index do
    selectable_column
    id_column
    column :start_date
    column :end_date
    column :amount
    column :precision
    column :status
    column :request_id

    actions
  end

  filter :id
  filter :start_date
  filter :end_date
  filter :amount
  filter :precision
  filter :status
  filter :request_id

  show do
    attributes_table do
      row :id
      row :start_date
      row :end_date
      row :amount
      row :precision
      row :status
      row :request_id
    end
  end
end
