```index.tsx
import './index.css'
import React from "react";
import { render } from "react-dom";
import { App } from "./App";

render(<App />, document.getElementById("root"));

```
```App.tsx
import React, { useState } from 'react'
import { v4 as uuidv4 } from 'uuid'
import CustomerList from './components/CustomerList'
import CustomerDetail from './components/CustomerDetail'
import CustomerForm from './components/CustomerForm'
import DeleteConfirmation from './components/DeleteConfirmation'
import { Customer } from './types'
// Sample data
const initialCustomers: Customer[] = [
  {
    id: '550e8400-e29b-41d4-a716-446655440000',
    firstName: 'Jane',
    lastName: 'Doe',
    emails: ['jane.doe@example.com'],
    privacySettings: {
      marketingEmailsEnabled: true,
      twoFactorEnabled: false,
    },
    phoneNumbers: [
      {
        type: 'mobile',
        number: '+12125551234',
      },
    ],
    address: {
      line1: '123 Main St',
      city: 'New York',
      state: 'NY',
      postalCode: '10001',
      country: 'US',
    },
  },
  {
    id: '550e8400-e29b-41d4-a716-446655440001',
    firstName: 'John',
    middleName: 'Michael',
    lastName: 'Smith',
    emails: ['john.smith@example.com', 'jsmith@work.com'],
    privacySettings: {
      marketingEmailsEnabled: false,
      twoFactorEnabled: true,
    },
    phoneNumbers: [
      {
        type: 'mobile',
        number: '+12125556789',
      },
      {
        type: 'work',
        number: '+12125550000',
      },
    ],
    address: {
      line1: '456 Park Ave',
      line2: 'Apt 303',
      city: 'New York',
      state: 'NY',
      postalCode: '10022',
      country: 'US',
    },
  },
]
type View = 'list' | 'detail' | 'create' | 'edit' | 'delete'
export function App() {
  const [customers, setCustomers] = useState<Customer[]>(initialCustomers)
  const [currentView, setCurrentView] = useState<View>('list')
  const [selectedCustomerId, setSelectedCustomerId] = useState<string | null>(
    null,
  )
  const selectedCustomer = selectedCustomerId
    ? customers.find((customer) => customer.id === selectedCustomerId)
    : null
  const handleViewCustomer = (id: string) => {
    setSelectedCustomerId(id)
    setCurrentView('detail')
  }
  const handleCreateCustomer = () => {
    setSelectedCustomerId(null)
    setCurrentView('create')
  }
  const handleEditCustomer = (id: string) => {
    setSelectedCustomerId(id)
    setCurrentView('edit')
  }
  const handleDeleteCustomer = (id: string) => {
    setSelectedCustomerId(id)
    setCurrentView('delete')
  }
  const handleConfirmDelete = () => {
    if (selectedCustomerId) {
      setCustomers(
        customers.filter((customer) => customer.id !== selectedCustomerId),
      )
      setSelectedCustomerId(null)
      setCurrentView('list')
    }
  }
  const handleCancelDelete = () => {
    setCurrentView('detail')
  }
  const handleSaveCustomer = (customerData: Omit<Customer, 'id'>) => {
    if (currentView === 'create') {
      const newCustomer: Customer = {
        ...customerData,
        id: uuidv4(),
      }
      setCustomers([...customers, newCustomer])
    } else if (currentView === 'edit' && selectedCustomerId) {
      setCustomers(
        customers.map((customer) =>
          customer.id === selectedCustomerId
            ? {
                ...customerData,
                id: customer.id,
              }
            : customer,
        ),
      )
    }
    setCurrentView('list')
  }
  const handleBackToList = () => {
    setCurrentView('list')
    setSelectedCustomerId(null)
  }
  return (
    <div className="min-h-screen bg-gray-50">
      <header className="bg-white shadow">
        <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
          <h1 className="text-3xl font-bold text-gray-900">
            Customer Profile Management
          </h1>
        </div>
      </header>
      <main className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
        {currentView === 'list' && (
          <CustomerList
            customers={customers}
            onView={handleViewCustomer}
            onCreateNew={handleCreateCustomer}
          />
        )}
        {currentView === 'detail' && selectedCustomer && (
          <CustomerDetail
            customer={selectedCustomer}
            onEdit={() => handleEditCustomer(selectedCustomer.id)}
            onDelete={() => handleDeleteCustomer(selectedCustomer.id)}
            onBack={handleBackToList}
          />
        )}
        {(currentView === 'create' || currentView === 'edit') && (
          <CustomerForm
            customer={currentView === 'edit' ? selectedCustomer : undefined}
            onSave={handleSaveCustomer}
            onCancel={handleBackToList}
          />
        )}
        {currentView === 'delete' && selectedCustomer && (
          <DeleteConfirmation
            customer={selectedCustomer}
            onConfirm={handleConfirmDelete}
            onCancel={handleCancelDelete}
          />
        )}
      </main>
    </div>
  )
}

```
```tailwind.config.js
export default {}
```
```index.css
/* PLEASE NOTE: THESE TAILWIND IMPORTS SHOULD NEVER BE DELETED */
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';
/* DO NOT DELETE THESE TAILWIND IMPORTS, OTHERWISE THE STYLING WILL NOT RENDER AT ALL */
```
```types.ts
export type PhoneNumberType = 'mobile' | 'home' | 'work' | 'other'
export interface PhoneNumber {
  type: PhoneNumberType
  number: string
}
export interface PostalAddress {
  line1: string
  line2?: string
  city: string
  state: string
  postalCode: string
  country: string
}
export interface PrivacySettings {
  marketingEmailsEnabled: boolean
  twoFactorEnabled: boolean
}
export interface Customer {
  id: string
  firstName: string
  middleName?: string
  lastName: string
  emails: string[]
  phoneNumbers: PhoneNumber[]
  address?: PostalAddress
  privacySettings: PrivacySettings
}

```
```components/CustomerList.tsx
import React from 'react'
import { Customer } from '../types'
import { PlusIcon, EyeIcon } from 'lucide-react'
interface CustomerListProps {
  customers: Customer[]
  onView: (id: string) => void
  onCreateNew: () => void
}
const CustomerList: React.FC<CustomerListProps> = ({
  customers,
  onView,
  onCreateNew,
}) => {
  return (
    <div className="bg-white shadow overflow-hidden sm:rounded-lg">
      <div className="px-4 py-5 sm:px-6 flex justify-between items-center">
        <h2 className="text-lg leading-6 font-medium text-gray-900">
          Customers
        </h2>
        <button
          onClick={onCreateNew}
          className="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
        >
          <PlusIcon className="h-4 w-4 mr-2" />
          Add Customer
        </button>
      </div>
      {customers.length === 0 ? (
        <div className="text-center py-10">
          <p className="text-gray-500">
            No customers found. Add your first customer to get started.
          </p>
        </div>
      ) : (
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th
                  scope="col"
                  className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                >
                  Name
                </th>
                <th
                  scope="col"
                  className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                >
                  Email
                </th>
                <th
                  scope="col"
                  className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                >
                  Phone
                </th>
                <th
                  scope="col"
                  className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                >
                  Location
                </th>
                <th scope="col" className="relative px-6 py-3">
                  <span className="sr-only">Actions</span>
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {customers.map((customer) => (
                <tr key={customer.id} className="hover:bg-gray-50">
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="text-sm font-medium text-gray-900">
                      {customer.firstName}{' '}
                      {customer.middleName ? customer.middleName + ' ' : ''}
                      {customer.lastName}
                    </div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="text-sm text-gray-900">
                      {customer.emails[0]}
                    </div>
                    {customer.emails.length > 1 && (
                      <div className="text-xs text-gray-500">
                        +{customer.emails.length - 1} more
                      </div>
                    )}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    {customer.phoneNumbers &&
                    customer.phoneNumbers.length > 0 ? (
                      <div className="text-sm text-gray-900">
                        {customer.phoneNumbers[0].number}
                      </div>
                    ) : (
                      <div className="text-sm text-gray-500">—</div>
                    )}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    {customer.address ? (
                      <div className="text-sm text-gray-900">
                        {customer.address.city}, {customer.address.state}
                      </div>
                    ) : (
                      <div className="text-sm text-gray-500">—</div>
                    )}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                    <button
                      onClick={() => onView(customer.id)}
                      className="inline-flex items-center text-indigo-600 hover:text-indigo-900"
                    >
                      <EyeIcon className="h-4 w-4 mr-1" />
                      View
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}
export default CustomerList

```
```components/CustomerDetail.tsx
import React from 'react'
import { Customer } from '../types'
import { ArrowLeftIcon, PencilIcon, TrashIcon } from 'lucide-react'
interface CustomerDetailProps {
  customer: Customer
  onEdit: () => void
  onDelete: () => void
  onBack: () => void
}
const CustomerDetail: React.FC<CustomerDetailProps> = ({
  customer,
  onEdit,
  onDelete,
  onBack,
}) => {
  return (
    <div className="bg-white shadow overflow-hidden sm:rounded-lg">
      <div className="px-4 py-5 sm:px-6 flex justify-between items-center">
        <div className="flex items-center">
          <button
            onClick={onBack}
            className="mr-4 text-gray-500 hover:text-gray-700"
          >
            <ArrowLeftIcon className="h-5 w-5" />
          </button>
          <h2 className="text-lg leading-6 font-medium text-gray-900">
            Customer Profile
          </h2>
        </div>
        <div className="flex space-x-2">
          <button
            onClick={onEdit}
            className="inline-flex items-center px-3 py-2 border border-gray-300 shadow-sm text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            <PencilIcon className="h-4 w-4 mr-1" />
            Edit
          </button>
          <button
            onClick={onDelete}
            className="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
          >
            <TrashIcon className="h-4 w-4 mr-1" />
            Delete
          </button>
        </div>
      </div>
      <div className="border-t border-gray-200 px-4 py-5 sm:px-6">
        <dl className="grid grid-cols-1 gap-x-4 gap-y-8 sm:grid-cols-2">
          <div className="sm:col-span-1">
            <dt className="text-sm font-medium text-gray-500">Full name</dt>
            <dd className="mt-1 text-sm text-gray-900">
              {customer.firstName}{' '}
              {customer.middleName ? customer.middleName + ' ' : ''}
              {customer.lastName}
            </dd>
          </div>
          <div className="sm:col-span-1">
            <dt className="text-sm font-medium text-gray-500">ID</dt>
            <dd className="mt-1 text-sm text-gray-900">{customer.id}</dd>
          </div>
          <div className="sm:col-span-1">
            <dt className="text-sm font-medium text-gray-500">
              Email addresses
            </dt>
            <dd className="mt-1 text-sm text-gray-900">
              <ul className="border border-gray-200 rounded-md divide-y divide-gray-200">
                {customer.emails.map((email, index) => (
                  <li
                    key={index}
                    className="pl-3 pr-4 py-3 flex items-center justify-between text-sm"
                  >
                    {email}
                  </li>
                ))}
              </ul>
            </dd>
          </div>
          <div className="sm:col-span-1">
            <dt className="text-sm font-medium text-gray-500">Phone numbers</dt>
            <dd className="mt-1 text-sm text-gray-900">
              <ul className="border border-gray-200 rounded-md divide-y divide-gray-200">
                {customer.phoneNumbers.map((phone, index) => (
                  <li
                    key={index}
                    className="pl-3 pr-4 py-3 flex items-center justify-between text-sm"
                  >
                    <div>
                      <span className="capitalize">{phone.type}</span>:{' '}
                      {phone.number}
                    </div>
                  </li>
                ))}
              </ul>
            </dd>
          </div>
          {customer.address && (
            <div className="sm:col-span-2">
              <dt className="text-sm font-medium text-gray-500">Address</dt>
              <dd className="mt-1 text-sm text-gray-900">
                <address className="not-italic">
                  {customer.address.line1}
                  <br />
                  {customer.address.line2 && (
                    <>
                      {customer.address.line2}
                      <br />
                    </>
                  )}
                  {customer.address.city}, {customer.address.state}{' '}
                  {customer.address.postalCode}
                  <br />
                  {customer.address.country}
                </address>
              </dd>
            </div>
          )}
          <div className="sm:col-span-2">
            <dt className="text-sm font-medium text-gray-500">
              Privacy Settings
            </dt>
            <dd className="mt-1 text-sm text-gray-900">
              <div className="space-y-2">
                <div className="flex items-center">
                  <span className="mr-2">Marketing Emails:</span>
                  <span
                    className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${customer.privacySettings.marketingEmailsEnabled ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}
                  >
                    {customer.privacySettings.marketingEmailsEnabled
                      ? 'Enabled'
                      : 'Disabled'}
                  </span>
                </div>
                <div className="flex items-center">
                  <span className="mr-2">Two-Factor Authentication:</span>
                  <span
                    className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${customer.privacySettings.twoFactorEnabled ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}
                  >
                    {customer.privacySettings.twoFactorEnabled
                      ? 'Enabled'
                      : 'Disabled'}
                  </span>
                </div>
              </div>
            </dd>
          </div>
        </dl>
      </div>
    </div>
  )
}
export default CustomerDetail

```
```components/CustomerForm.tsx
import React, { useState } from 'react'
import { Customer, PhoneNumber, PostalAddress } from '../types'
import { ArrowLeftIcon, PlusIcon, TrashIcon } from 'lucide-react'
interface CustomerFormProps {
  customer?: Customer
  onSave: (customer: Omit<Customer, 'id'>) => void
  onCancel: () => void
}
const CustomerForm: React.FC<CustomerFormProps> = ({
  customer,
  onSave,
  onCancel,
}) => {
  const [firstName, setFirstName] = useState(customer?.firstName || '')
  const [middleName, setMiddleName] = useState(customer?.middleName || '')
  const [lastName, setLastName] = useState(customer?.lastName || '')
  const [emails, setEmails] = useState<string[]>(customer?.emails || [''])
  const [phoneNumbers, setPhoneNumbers] = useState<PhoneNumber[]>(
    customer?.phoneNumbers || [
      {
        type: 'mobile',
        number: '',
      },
    ],
  )
  const [address, setAddress] = useState<PostalAddress>(
    customer?.address || {
      line1: '',
      line2: '',
      city: '',
      state: '',
      postalCode: '',
      country: '',
    },
  )
  const [privacySettings, setPrivacySettings] = useState({
    marketingEmailsEnabled:
      customer?.privacySettings?.marketingEmailsEnabled || false,
    twoFactorEnabled: customer?.privacySettings?.twoFactorEnabled || false,
  })
  const [errors, setErrors] = useState<Record<string, string>>({})
  const validateForm = () => {
    const newErrors: Record<string, string> = {}
    if (!firstName.trim()) newErrors.firstName = 'First name is required'
    if (!lastName.trim()) newErrors.lastName = 'Last name is required'
    // Validate emails
    if (emails.length === 0 || !emails[0].trim()) {
      newErrors.emails = 'At least one email is required'
    } else {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
      for (let i = 0; i < emails.length; i++) {
        if (!emailRegex.test(emails[i])) {
          newErrors[`email_${i}`] = 'Invalid email format'
        }
      }
    }
    // Validate phone numbers
    if (phoneNumbers.length === 0) {
      newErrors.phoneNumbers = 'At least one phone number is required'
    } else {
      for (let i = 0; i < phoneNumbers.length; i++) {
        if (!phoneNumbers[i].number.trim()) {
          newErrors[`phoneNumber_${i}`] = 'Phone number is required'
        } else if (!/^\+?[1-9]\d{1,14}$/.test(phoneNumbers[i].number)) {
          newErrors[`phoneNumber_${i}`] = 'Invalid phone number format (E.164)'
        }
      }
    }
    // Validate address if provided
    if (
      address.line1 ||
      address.city ||
      address.state ||
      address.postalCode ||
      address.country
    ) {
      if (!address.line1.trim())
        newErrors['address.line1'] = 'Street address is required'
      if (!address.city.trim()) newErrors['address.city'] = 'City is required'
      if (!address.state.trim())
        newErrors['address.state'] = 'State is required'
      if (!address.postalCode.trim())
        newErrors['address.postalCode'] = 'Postal code is required'
      if (!address.country.trim())
        newErrors['address.country'] = 'Country is required'
      if (address.country.trim() && address.country.length !== 2) {
        newErrors['address.country'] = 'Country must be a 2-letter ISO code'
      }
    }
    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }
  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    if (validateForm()) {
      const customerData: Omit<Customer, 'id'> = {
        firstName,
        lastName,
        emails: emails.filter((email) => email.trim() !== ''),
        phoneNumbers: phoneNumbers.filter(
          (phone) => phone.number.trim() !== '',
        ),
        privacySettings,
      }
      if (middleName.trim()) customerData.middleName = middleName
      if (
        address.line1.trim() &&
        address.city.trim() &&
        address.state.trim() &&
        address.postalCode.trim() &&
        address.country.trim()
      ) {
        customerData.address = {
          line1: address.line1,
          city: address.city,
          state: address.state,
          postalCode: address.postalCode,
          country: address.country,
        }
        if (address.line2.trim()) {
          customerData.address.line2 = address.line2
        }
      }
      onSave(customerData)
    }
  }
  const addEmail = () => {
    setEmails([...emails, ''])
  }
  const removeEmail = (index: number) => {
    if (emails.length > 1) {
      setEmails(emails.filter((_, i) => i !== index))
    }
  }
  const updateEmail = (index: number, value: string) => {
    setEmails(emails.map((email, i) => (i === index ? value : email)))
  }
  const addPhoneNumber = () => {
    setPhoneNumbers([
      ...phoneNumbers,
      {
        type: 'mobile',
        number: '',
      },
    ])
  }
  const removePhoneNumber = (index: number) => {
    if (phoneNumbers.length > 1) {
      setPhoneNumbers(phoneNumbers.filter((_, i) => i !== index))
    }
  }
  const updatePhoneNumber = (
    index: number,
    field: keyof PhoneNumber,
    value: any,
  ) => {
    setPhoneNumbers(
      phoneNumbers.map((phone, i) =>
        i === index
          ? {
              ...phone,
              [field]: value,
            }
          : phone,
      ),
    )
  }
  const updateAddress = (field: keyof PostalAddress, value: string) => {
    setAddress({
      ...address,
      [field]: value,
    })
  }
  return (
    <div className="bg-white shadow overflow-hidden sm:rounded-lg">
      <div className="px-4 py-5 sm:px-6 flex items-center">
        <button
          onClick={onCancel}
          className="mr-4 text-gray-500 hover:text-gray-700"
        >
          <ArrowLeftIcon className="h-5 w-5" />
        </button>
        <h2 className="text-lg leading-6 font-medium text-gray-900">
          {customer ? 'Edit Customer' : 'Create Customer'}
        </h2>
      </div>
      <div className="border-t border-gray-200 px-4 py-5 sm:px-6">
        <form onSubmit={handleSubmit} className="space-y-8">
          <div className="space-y-6">
            <h3 className="text-lg font-medium leading-6 text-gray-900">
              Personal Information
            </h3>
            <div className="grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
              <div className="sm:col-span-2">
                <label
                  htmlFor="firstName"
                  className="block text-sm font-medium text-gray-700"
                >
                  First name*
                </label>
                <div className="mt-1">
                  <input
                    type="text"
                    name="firstName"
                    id="firstName"
                    value={firstName}
                    onChange={(e) => setFirstName(e.target.value)}
                    className={`shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md ${errors.firstName ? 'border-red-300' : ''}`}
                  />
                  {errors.firstName && (
                    <p className="mt-2 text-sm text-red-600">
                      {errors.firstName}
                    </p>
                  )}
                </div>
              </div>
              <div className="sm:col-span-2">
                <label
                  htmlFor="middleName"
                  className="block text-sm font-medium text-gray-700"
                >
                  Middle name
                </label>
                <div className="mt-1">
                  <input
                    type="text"
                    name="middleName"
                    id="middleName"
                    value={middleName}
                    onChange={(e) => setMiddleName(e.target.value)}
                    className="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
                  />
                </div>
              </div>
              <div className="sm:col-span-2">
                <label
                  htmlFor="lastName"
                  className="block text-sm font-medium text-gray-700"
                >
                  Last name*
                </label>
                <div className="mt-1">
                  <input
                    type="text"
                    name="lastName"
                    id="lastName"
                    value={lastName}
                    onChange={(e) => setLastName(e.target.value)}
                    className={`shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md ${errors.lastName ? 'border-red-300' : ''}`}
                  />
                  {errors.lastName && (
                    <p className="mt-2 text-sm text-red-600">
                      {errors.lastName}
                    </p>
                  )}
                </div>
              </div>
            </div>
          </div>
          <div className="space-y-6">
            <div className="flex justify-between items-center">
              <h3 className="text-lg font-medium leading-6 text-gray-900">
                Email Addresses*
              </h3>
              <button
                type="button"
                onClick={addEmail}
                className="inline-flex items-center px-3 py-1 border border-transparent text-xs font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
              >
                <PlusIcon className="h-4 w-4 mr-1" />
                Add Email
              </button>
            </div>
            {emails.map((email, index) => (
              <div key={index} className="flex items-center space-x-2">
                <div className="flex-grow">
                  <input
                    type="email"
                    value={email}
                    onChange={(e) => updateEmail(index, e.target.value)}
                    className={`shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md ${errors[`email_${index}`] ? 'border-red-300' : ''}`}
                    placeholder="email@example.com"
                  />
                  {errors[`email_${index}`] && (
                    <p className="mt-2 text-sm text-red-600">
                      {errors[`email_${index}`]}
                    </p>
                  )}
                </div>
                {emails.length > 1 && (
                  <button
                    type="button"
                    onClick={() => removeEmail(index)}
                    className="inline-flex items-center p-1 border border-transparent rounded-full shadow-sm text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
                  >
                    <TrashIcon className="h-4 w-4" />
                  </button>
                )}
              </div>
            ))}
            {errors.emails && (
              <p className="mt-2 text-sm text-red-600">{errors.emails}</p>
            )}
          </div>
          <div className="space-y-6">
            <div className="flex justify-between items-center">
              <h3 className="text-lg font-medium leading-6 text-gray-900">
                Phone Numbers*
              </h3>
              <button
                type="button"
                onClick={addPhoneNumber}
                className="inline-flex items-center px-3 py-1 border border-transparent text-xs font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
              >
                <PlusIcon className="h-4 w-4 mr-1" />
                Add Phone
              </button>
            </div>
            {phoneNumbers.map((phone, index) => (
              <div key={index} className="flex items-center space-x-2">
                <div className="w-1/4">
                  <select
                    value={phone.type}
                    onChange={(e) =>
                      updatePhoneNumber(index, 'type', e.target.value)
                    }
                    className="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
                  >
                    <option value="mobile">Mobile</option>
                    <option value="home">Home</option>
                    <option value="work">Work</option>
                    <option value="other">Other</option>
                  </select>
                </div>
                <div className="flex-grow">
                  <input
                    type="tel"
                    value={phone.number}
                    onChange={(e) =>
                      updatePhoneNumber(index, 'number', e.target.value)
                    }
                    placeholder="+1234567890"
                    className={`shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md ${errors[`phoneNumber_${index}`] ? 'border-red-300' : ''}`}
                  />
                  {errors[`phoneNumber_${index}`] && (
                    <p className="mt-2 text-sm text-red-600">
                      {errors[`phoneNumber_${index}`]}
                    </p>
                  )}
                </div>
                {phoneNumbers.length > 1 && (
                  <button
                    type="button"
                    onClick={() => removePhoneNumber(index)}
                    className="inline-flex items-center p-1 border border-transparent rounded-full shadow-sm text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
                  >
                    <TrashIcon className="h-4 w-4" />
                  </button>
                )}
              </div>
            ))}
            {errors.phoneNumbers && (
              <p className="mt-2 text-sm text-red-600">{errors.phoneNumbers}</p>
            )}
          </div>
          <div className="space-y-6">
            <h3 className="text-lg font-medium leading-6 text-gray-900">
              Address (Optional)
            </h3>
            <div className="grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
              <div className="sm:col-span-6">
                <label
                  htmlFor="line1"
                  className="block text-sm font-medium text-gray-700"
                >
                  Street address
                </label>
                <div className="mt-1">
                  <input
                    type="text"
                    name="line1"
                    id="line1"
                    value={address.line1}
                    onChange={(e) => updateAddress('line1', e.target.value)}
                    className={`shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md ${errors['address.line1'] ? 'border-red-300' : ''}`}
                  />
                  {errors['address.line1'] && (
                    <p className="mt-2 text-sm text-red-600">
                      {errors['address.line1']}
                    </p>
                  )}
                </div>
              </div>
              <div className="sm:col-span-6">
                <label
                  htmlFor="line2"
                  className="block text-sm font-medium text-gray-700"
                >
                  Apartment, suite, etc.
                </label>
                <div className="mt-1">
                  <input
                    type="text"
                    name="line2"
                    id="line2"
                    value={address.line2 || ''}
                    onChange={(e) => updateAddress('line2', e.target.value)}
                    className="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
                  />
                </div>
              </div>
              <div className="sm:col-span-2">
                <label
                  htmlFor="city"
                  className="block text-sm font-medium text-gray-700"
                >
                  City
                </label>
                <div className="mt-1">
                  <input
                    type="text"
                    name="city"
                    id="city"
                    value={address.city}
                    onChange={(e) => updateAddress('city', e.target.value)}
                    className={`shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md ${errors['address.city'] ? 'border-red-300' : ''}`}
                  />
                  {errors['address.city'] && (
                    <p className="mt-2 text-sm text-red-600">
                      {errors['address.city']}
                    </p>
                  )}
                </div>
              </div>
              <div className="sm:col-span-2">
                <label
                  htmlFor="state"
                  className="block text-sm font-medium text-gray-700"
                >
                  State / Province
                </label>
                <div className="mt-1">
                  <input
                    type="text"
                    name="state"
                    id="state"
                    value={address.state}
                    onChange={(e) => updateAddress('state', e.target.value)}
                    className={`shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md ${errors['address.state'] ? 'border-red-300' : ''}`}
                  />
                  {errors['address.state'] && (
                    <p className="mt-2 text-sm text-red-600">
                      {errors['address.state']}
                    </p>
                  )}
                </div>
              </div>
              <div className="sm:col-span-2">
                <label
                  htmlFor="postalCode"
                  className="block text-sm font-medium text-gray-700"
                >
                  ZIP / Postal code
                </label>
                <div className="mt-1">
                  <input
                    type="text"
                    name="postalCode"
                    id="postalCode"
                    value={address.postalCode}
                    onChange={(e) =>
                      updateAddress('postalCode', e.target.value)
                    }
                    className={`shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md ${errors['address.postalCode'] ? 'border-red-300' : ''}`}
                  />
                  {errors['address.postalCode'] && (
                    <p className="mt-2 text-sm text-red-600">
                      {errors['address.postalCode']}
                    </p>
                  )}
                </div>
              </div>
              <div className="sm:col-span-3">
                <label
                  htmlFor="country"
                  className="block text-sm font-medium text-gray-700"
                >
                  Country (2-letter code)
                </label>
                <div className="mt-1">
                  <input
                    type="text"
                    name="country"
                    id="country"
                    value={address.country}
                    onChange={(e) =>
                      updateAddress(
                        'country',
                        e.target.value.toUpperCase().slice(0, 2),
                      )
                    }
                    placeholder="US"
                    maxLength={2}
                    className={`shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md ${errors['address.country'] ? 'border-red-300' : ''}`}
                  />
                  {errors['address.country'] && (
                    <p className="mt-2 text-sm text-red-600">
                      {errors['address.country']}
                    </p>
                  )}
                </div>
              </div>
            </div>
          </div>
          <div className="space-y-6">
            <h3 className="text-lg font-medium leading-6 text-gray-900">
              Privacy Settings*
            </h3>
            <div className="space-y-4">
              <div className="flex items-start">
                <div className="flex items-center h-5">
                  <input
                    id="marketingEmailsEnabled"
                    name="marketingEmailsEnabled"
                    type="checkbox"
                    checked={privacySettings.marketingEmailsEnabled}
                    onChange={(e) =>
                      setPrivacySettings({
                        ...privacySettings,
                        marketingEmailsEnabled: e.target.checked,
                      })
                    }
                    className="focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded"
                  />
                </div>
                <div className="ml-3 text-sm">
                  <label
                    htmlFor="marketingEmailsEnabled"
                    className="font-medium text-gray-700"
                  >
                    Marketing Emails
                  </label>
                  <p className="text-gray-500">
                    Receive emails about promotions, news, and updates.
                  </p>
                </div>
              </div>
              <div className="flex items-start">
                <div className="flex items-center h-5">
                  <input
                    id="twoFactorEnabled"
                    name="twoFactorEnabled"
                    type="checkbox"
                    checked={privacySettings.twoFactorEnabled}
                    onChange={(e) =>
                      setPrivacySettings({
                        ...privacySettings,
                        twoFactorEnabled: e.target.checked,
                      })
                    }
                    className="focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded"
                  />
                </div>
                <div className="ml-3 text-sm">
                  <label
                    htmlFor="twoFactorEnabled"
                    className="font-medium text-gray-700"
                  >
                    Two-Factor Authentication
                  </label>
                  <p className="text-gray-500">
                    Enable two-factor authentication for added security.
                  </p>
                </div>
              </div>
            </div>
          </div>
          <div className="pt-5">
            <div className="flex justify-end">
              <button
                type="button"
                onClick={onCancel}
                className="bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
              >
                Cancel
              </button>
              <button
                type="submit"
                className="ml-3 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
              >
                Save
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>
  )
}
export default CustomerForm

```
```components/DeleteConfirmation.tsx
import React from 'react'
import { Customer } from '../types'
import { AlertTriangleIcon } from 'lucide-react'
interface DeleteConfirmationProps {
  customer: Customer
  onConfirm: () => void
  onCancel: () => void
}
const DeleteConfirmation: React.FC<DeleteConfirmationProps> = ({
  customer,
  onConfirm,
  onCancel,
}) => {
  return (
    <div className="fixed inset-0 bg-gray-500 bg-opacity-75 flex items-center justify-center p-4">
      <div className="bg-white rounded-lg overflow-hidden shadow-xl max-w-md w-full">
        <div className="bg-red-50 p-4">
          <div className="flex">
            <div className="flex-shrink-0">
              <AlertTriangleIcon className="h-5 w-5 text-red-400" />
            </div>
            <div className="ml-3">
              <h3 className="text-sm font-medium text-red-800">
                Delete Customer Profile
              </h3>
            </div>
          </div>
        </div>
        <div className="px-4 py-5 sm:p-6">
          <div className="sm:flex sm:items-start">
            <div className="mt-3 text-center sm:mt-0 sm:text-left">
              <h3 className="text-lg leading-6 font-medium text-gray-900">
                Delete {customer.firstName} {customer.lastName}'s profile?
              </h3>
              <div className="mt-2">
                <p className="text-sm text-gray-500">
                  Are you sure you want to delete this customer profile? All of
                  their data will be permanently removed from our servers. This
                  action cannot be undone.
                </p>
              </div>
            </div>
          </div>
        </div>
        <div className="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
          <button
            type="button"
            className="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm"
            onClick={onConfirm}
          >
            Delete
          </button>
          <button
            type="button"
            className="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:w-auto sm:text-sm"
            onClick={onCancel}
          >
            Cancel
          </button>
        </div>
      </div>
    </div>
  )
}
export default DeleteConfirmation

```