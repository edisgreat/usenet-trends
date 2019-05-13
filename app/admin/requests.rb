ActiveAdmin.register Request do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params :start_date, :end_date, :query, :cookie, :author_email, :author_name, :status, :authstring

  form do |f|
    f.inputs 'Details' do
      f.input :start_date
      f.input :end_date
      f.input :query
      f.input :cookie
      f.input :author_email
      f.input :author_name
      f.input :status
      f.input :authstring
    end

    actions
  end
  
  index do
    selectable_column
    id_column
    column :start_date
    column :end_date
    column :query
    column :cookie
    column :author_email
    column :author_name
    column :status
    column :authstring

    actions
  end

  filter :id
  filter :start_date
  filter :end_date
  filter :query
  filter :cookie
  filter :author_email
  filter :author_name
  filter :status
  filter :authstring

  show do
    attributes_table do
      row :id
      row :start_date
      row :end_date
      row :query
      row :cookie
      row :author_email
      row :author_name
      row :status
      row :authstring
    end
  end
end
