# Domain Driven Design

## 1. Bounded Context: Client Profile

**Context Name:** ClientProfileContext
**Description:**
The ClientProfileContext encapsulates all business logic around viewing, editing, and storing a user’s profile data (personal info, photo, privacy settings). It exposes application services for the Web and Mobile UIs to manipulate profiles and emits domain events consumed by other contexts (e.g., Notification, Audit).

**Key Collaborators (Other Contexts):**

* **AuthenticationContext** — ensures the user is authorized to view/edit their profile.
* **NotificationContext** — listens for profile changes to send confirmation emails.
* **AuditContext** — logs domain events (e.g., `ProfileUpdatedEvent`).
* **StorageContext** — abstracts interaction with S3 or equivalent.

---

## 2. Ubiquitous Language

| Term                | Definition                                                                                 |
| ------------------- | ------------------------------------------------------------------------------------------ |
| Client Profile      | The aggregate root representing a user’s personal data, photo, and privacy preferences.    |
| Profile Photo       | A value object capturing the URL, file type, and size metadata of the user’s avatar image. |
| Privacy Settings    | A value object holding boolean flags (e.g. `marketingEmailsEnabled`, `twoFactorEnabled`).  |
| UpdateProfileInfo   | A user action to modify name, email, phone, or address.                                    |
| UploadPhoto         | A user action to validate and upload a new profile photo.                                  |
| TogglePrivacyOption | A user action to change a specific privacy setting.                                        |
| ProfileUpdatedEvent | A domain event emitted when any part of the profile is successfully updated.               |
| PhotoUploadedEvent  | A domain event emitted when a new profile photo is stored.                                 |

---

## 3. Aggregate: ClientProfile

### 3.1. Aggregate Root: `ClientProfile`

* **Identifier:** `ClientProfileId` (UUID)
* **State:**

    * `FullName` (string)
    * `Email` (`EmailAddress` VO)
    * `Phone` (`PhoneNumber` VO)
    * `Address` (string)
    * `ProfilePhoto` (`ProfilePhoto` VO)
    * `PrivacySettings` (`PrivacySettings` VO)
* **Invariants:**

    * `Email` must be valid and unique.
    * `Phone` must match required format if provided.
    * Photo file size ≤ 5 MB and type ∈ {JPEG, PNG}.
* **Behaviors (Methods):**

    * `updatePersonalInfo(fullName, EmailAddress, PhoneNumber, address)`
    * `uploadPhoto(ProfilePhoto)`
    * `togglePrivacyOption(optionKey)`

### 3.2. Value Objects

#### 3.2.1. `EmailAddress`

* **Fields:** `value` (string)
* **Validation:** RFC-compliant email format.
* **Immutability:** Yes.

#### 3.2.2. `PhoneNumber`

* **Fields:** `value` (string)
* **Validation:** Regex for E.164 or specified country format.
* **Immutability:** Yes.

#### 3.2.3. `ProfilePhoto`

* **Fields:**

    * `url` (string)
    * `fileName` (string)
    * `fileSizeInBytes` (int)
    * `contentType` (string)
* **Validation:** `fileSizeInBytes ≤ 5 MB`; `contentType ∈ {"image/jpeg","image/png"}`.
* **Immutability:** Yes.

#### 3.2.4. `PrivacySettings`

* **Fields:**

    * `marketingEmailsEnabled` (bool)
    * `twoFactorEnabled` (bool)
* **Behavior:** `toggleMarketingEmails()`, `toggleTwoFactor()`.

---

## 4. Domain Services

### 4.1. `PhotoStorageService`

* **Responsibility:** Handles uploading of `ProfilePhoto` VO to external storage (e.g., S3) and returns the accessible URL.
* **Interface:**

  ```text
  interface PhotoStorageService {
      ProfilePhoto upload(fileStream, fileName, contentType) throws StorageException;
  }
  ```

### 4.2. `ValidationService`

* **Responsibility:** Shared logic for additional validations (e.g., file size, file type). Could be part of domain or an application-layer helper.

---

## 5. Domain Events

| Event Name            | Payload                                                | Description                                          |
| --------------------- | ------------------------------------------------------ | ---------------------------------------------------- |
| `ProfileUpdatedEvent` | `clientProfileId`, `updatedFields: List<String>`       | Emitted after personal info is successfully updated. |
| `PhotoUploadedEvent`  | `clientProfileId`, `photoUrl`, `fileName`, `timestamp` | Emitted after photo storage and profile update.      |
| `PrivacyToggledEvent` | `clientProfileId`, `settingKey`, `newValue`            | Emitted when a privacy setting is changed.           |

---

## 6. Repositories

### 6.1. `ClientProfileRepository`

* **Responsibility:** Persist and retrieve `ClientProfile` aggregates.
* **Interface:**

  ```text
  interface ClientProfileRepository {
      ClientProfile findById(ClientProfileId id);
      void save(ClientProfile profile);
      // Optional: findByEmail(EmailAddress email) for uniqueness checks
  }
  ```

---

## 7. Application Services (Use Cases)

These orchestrate interactions between the UI, domain model, and domain services.

### 7.1. `ProfileApplicationService`

* **Methods:**

    * `viewProfile(userId): ClientProfileDto`
    * `updateProfileInfo(userId, UpdateProfileInfoCommand): void`
    * `uploadProfilePhoto(userId, UploadPhotoCommand): void`
    * `changePrivacySetting(userId, TogglePrivacyCommand): void`
* **Workflow Example (`uploadProfilePhoto`):**

    1. **Authorize** via AuthenticationContext.
    2. **Retrieve** `ClientProfile` via repository.
    3. **Validate** incoming file via `ValidationService`.
    4. **Call** `PhotoStorageService.upload(...)` to get `ProfilePhoto` VO.
    5. **Invoke** `clientProfile.uploadPhoto(profilePhoto)` on aggregate.
    6. \*\*Repository.save(clientProfile)\`.
    7. **Publish** `PhotoUploadedEvent`.

---

## 8. Integration & Infrastructure

* **Adapters:**

    * **REST API Controller** (Web & Mobile): maps HTTP requests to commands handled by `ProfileApplicationService`.
    * **GraphQL Resolver** (if using GraphQL): similar mapping.
    * **CLI/Terminal Agent** (for AI tools): CLI commands can call service methods when wired into an AI agent.

* **External Systems:**

    * **Authentication Service** (OAuth/OIDC).
    * **Object Storage** (AWS S3 or equivalent).
    * **Message Broker** (e.g., Kafka) for publishing domain events to other contexts.

* **Persistence:**

    * Relational DB (e.g., PostgreSQL) or document store; store profile data in a `client_profiles` table/collection.
    * Photo metadata in the same DB or a separate `profile_photos` table.

---

## 9. Context Map

```text
[ ClientProfileContext ] --> (publishes) --> [ NotificationContext ]
[ ClientProfileContext ] --> (publishes) --> [ AuditContext ]
[ ClientProfileContext ] --> (uses)     --> [ StorageContext ]
[ ClientProfileContext ] --> (uses/auth)--> [ AuthenticationContext ]
```

---

## 10. Summary

This DDD document defines a clear **bounded context** for the Client Profile module, with a well-scoped **aggregate** (`ClientProfile`), **value objects**, **domain services**, **events**, **repositories**, and **application services**. It also maps out integration points and context relationships. Engineers can now use this model to drive both human-written code and AI-assisted code generation, ensuring that implementations faithfully reflect the domain’s invariants and behaviors.

EOF