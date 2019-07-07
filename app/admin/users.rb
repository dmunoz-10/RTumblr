ActiveAdmin.register User do
  permit_params :first_name, :last_name, :username, :gender, :email, :password,
                :password_confirmation, :birth_date, :phone_number

  scope :all
  scope :males
  scope :females
  scope :transgenders
  scope :transsexuals
  scope :rather_not_to_say
  scope :other

  active_admin_paranoia

  index do
    selectable_column
    column :first_name
    column :last_name
    column :username
    column :gender
    column :email
    column :created_at
    column :updated_at
    column :deleted_at do |model|
      if model.deleted_at.present?
        "#{model.deleted_at}"
      else
        status_tag 'Empty'
      end
    end
    actions
  end

  form do |f|
    f.inputs 'User details' do
      f.input :first_name
      f.input :last_name
      f.input :username
      f.input :gender
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :birth_date
      f.input :phone_number
    end
    f.actions
  end
end
