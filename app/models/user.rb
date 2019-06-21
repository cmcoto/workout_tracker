class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  after_create :create_tenant
  after_destroy :delete_tenant

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, request_keys: [:subdomain]

  
  validates :email, uniqueness: true

  def create_tenant
    Apartment::Tenant.create(subdomain)
  end  

  #Delete the Tenant after_destroy
  def delete_tenant
    Apartment::Tenant.drop(subdomain)
  end 

  #for devise authentication
  def self.find_for_authentication(warden_conditions)
    where(email: warden_conditions[:email], subdomain: warden_conditions[:subdomain]).first
  end  

end
