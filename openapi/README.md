# OpenAPI Configuration Documentation

This document provides detailed information about all configuration parameters available in the OpenAPI service.

## Overview

The OpenAPI service configuration is defined in `openapi.yao` and includes:

- 🔧 **Base Configuration** - OpenAPI endpoint at `/v1` with configurable providers
- 🔐 **OAuth 2.0 & 2.1 Support** - Configurable OAuth features with OAuth 2.1 enabled by default
- 🎫 **Multiple Token Formats** - JWT access tokens and opaque refresh tokens
- 🛡️ **Security Features** - mTLS, PKCE, rate limiting, and brute force protection
- 🏗️ **Advanced Flows** - Device flow, token exchange, and pushed authorization requests
- 🔄 **Token Management** - Token binding, revocation, and introspection capabilities

## Configuration Structure

```yaml
├── baseurl          # Base URL for OpenAPI endpoints (default: "/v1")
├── store            # OAuth data store for persistent data (default: "__yao.oauth.store" - Badger)
├── cache            # OAuth cache store for temporary data (default: "__yao.oauth.cache" - LRU)
├── providers        # Data provider configuration
│   ├── user         # User provider model (default: "__yao.user")
│   └── client       # Client KV store (default: "__yao.oauth.client" - Badger)
└── oauth            # OAuth configuration
    ├── issuer_url    # OAuth server issuer URL (required)
    ├── signing       # Token signing configuration
    ├── token         # Token lifecycle configuration
    ├── security      # Security features configuration
    ├── client        # Client default configuration
    └── features      # OAuth 2.0/2.1 feature flags
```

---

## Configuration Format Guidelines

### Duration Format

All time duration fields in the configuration use **human-readable string format** that supports standard Go duration syntax:

**Supported Units:**

- `ns` (nanoseconds) - `500ns`
- `us` (microseconds) - `100us`
- `ms` (milliseconds) - `250ms`
- `s` (seconds) - `30s`
- `m` (minutes) - `15m`
- `h` (hours) - `24h`

**Format Examples:**

```json
{
  "access_token_lifetime": "1h", // 1 hour
  "refresh_token_lifetime": "24h", // 24 hours
  "authorization_code_lifetime": "10m", // 10 minutes
  "device_code_interval": "5s", // 5 seconds
  "cert_rotation_interval": "168h" // 7 days (7 × 24h)
}
```

**Combined Durations:**

```json
{
  "session_timeout": "1h30m", // 1 hour 30 minutes
  "cleanup_interval": "2h45m30s" // 2 hours 45 minutes 30 seconds
}
```

**Special Values:**

- `"0"` or `"0s"` - Zero duration (no timeout/immediate expiration)
- Empty string `""` - Use system default

### Path Format

Certificate and file paths follow these resolution rules:

1. **Relative Paths** (Recommended): Resolved from `{YAO_ROOT}/openapi/certs/`

   - `"signing-cert.pem"` → `{YAO_ROOT}/openapi/certs/signing-cert.pem`

2. **Subdirectory Paths**: Organize certificates in subdirectories

   - `"ssl/prod-cert.pem"` → `{YAO_ROOT}/openapi/certs/ssl/prod-cert.pem`

3. **Absolute Paths**: Used as-is without modification
   - `"/etc/ssl/certs/oauth.pem"` → `/etc/ssl/certs/oauth.pem`

---

## Base Configuration

### `baseurl`

- **Type**: `string`
- **Required**: Yes
- **Default**: `/v1`
- **Description**: Base URL path for OpenAPI endpoints

**Example:**

```json
"baseurl": "/v1"
```

---

## Store Configuration

### `store`

- **Type**: `string`
- **Required**: Yes
- **Default**: `__yao.oauth.store` (uses Badger KV store)
- **Description**: OAuth data store for persistent OAuth data (authorization codes, refresh tokens, session data) using Yao Store KV engine
- **Custom**: Can be any Yao Store (Redis, Badger, MongoDB, etc.) for persistent OAuth data
- **Storage Path**: `{{ YAO_DATA_ROOT }}/stores/oauth/store`

### `cache`

- **Type**: `string`
- **Required**: Yes
- **Default**: `__yao.oauth.cache` (uses LRU cache strategy)
- **Description**: Cache store for temporary OAuth data (access tokens, temporary sessions) using Yao Store KV engine
- **Custom**: Can be any Yao Store (Redis, Memory, etc.) for temporary KV data
- **Cache Size**: 8192 entries

## Providers Configuration

### `providers`

Data provider configuration for OAuth service components.

#### `user`

- **Type**: `string`
- **Required**: Yes
- **Default**: `__yao.user`
- **Description**: User provider model for authentication and authorization
- **Custom**: Can be any Yao model with required fields

#### `client`

- **Type**: `string`
- **Required**: Yes
- **Default**: `__yao.oauth.client` (uses Badger KV store)
- **Description**: Client store for OAuth client registration and credentials using Yao Store KV engine
- **Custom**: Can be any Yao Store (Redis, Badger, MongoDB, etc.) for OAuth client KV data
- **Storage Path**: `{{ YAO_DATA_ROOT }}/stores/oauth/client`

**Example:**

```json
{
  "store": "redis.oauth_data", // Redis KV store for OAuth data (⚠️ potential data loss)
  "cache": "redis.oauth_cache", // Redis KV store for cache data (acceptable)
  "providers": {
    "user": "custom.users", // Custom user model
    "client": "mongodb.oauth_clients" // MongoDB store for client data
  }
}
```

**High-Performance Configuration:**

```json
{
  "store": "__yao.oauth.store", // Default Badger store for persistence
  "cache": "redis.oauth_cache", // Redis cache for distributed caching
  "providers": {
    "user": "__yao.user",
    "client": "mongodb.oauth_clients" // MongoDB for complex client queries
  }
}
```

**Storage Engine Details:**

- **Default OAuth store**: Badger KV (persistent, embedded)
- **Default cache store**: LRU cache (in-memory, 8192 entries)
- **Default client store**: Badger KV (persistent, embedded)
- **Custom options**: Redis, Badger, MongoDB, Memory, etc.

**Recommended Usage:**

- **OAuth store**: Badger (default), MongoDB for critical data; Redis for non-critical data
- **Cache store**: LRU Cache (default), Redis for distributed scenarios
- **Client store**: Badger (default), MongoDB for complex queries; Redis for non-critical data

**Critical vs Non-Critical Data:**

- **Critical**: OAuth client registrations, user credentials (use Badger/MongoDB)
- **Non-Critical**: Access tokens, sessions, temporary data (Redis acceptable)

**Performance Characteristics:**

| Store     | Type        | Persistence     | Performance | Use Case                        |
| --------- | ----------- | --------------- | ----------- | ------------------------------- |
| Badger    | Embedded KV | Persistent      | High        | OAuth data, client registration |
| LRU Cache | In-memory   | Non-persistent  | Very High   | Access tokens, sessions         |
| Memory    | In-memory   | Non-persistent  | Very High   | Simple cache scenarios          |
| Redis     | External KV | Semi-persistent | High        | Distributed cache/storage       |
| MongoDB   | Document DB | Persistent      | Medium      | Complex queries, analytics      |

**Persistence Details:**

- **Persistent**: Real-time write to disk, no data loss risk
- **Semi-persistent**: Periodic snapshots + write-ahead logs, potential data loss (1-60s)
- **Non-persistent**: Memory only, data lost on restart

**Redis Persistence Mechanisms:**

- **RDB (Snapshot)**: Periodic disk snapshots, data loss risk between snapshots
- **AOF (Append-Only File)**: Logs write operations, configurable fsync (1s-30s data loss)
- **Hybrid**: RDB + AOF for better recovery, still not real-time

---

## OAuth Storage Architecture

### Three-Layer Storage Design

The OAuth service uses a sophisticated three-layer storage architecture for optimal performance and data safety:

```
┌─────────────────────────────────────────────────────────────┐
│                OAuth Storage Architecture                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  🗄️  OAuth Data Store (__yao.oauth.store)                 │
│     ├── Authorization codes                                 │
│     ├── Refresh tokens                                      │
│     ├── Session data                                        │
│     └── OAuth flow persistence                              │
│     Storage: {{ YAO_DATA_ROOT }}/stores/oauth/store         │
│                                                             │
│  ⚡ OAuth Cache Store (__yao.oauth.cache)                  │
│     ├── Access tokens (temporary)                           │
│     ├── Rate limiting counters                              │
│     ├── Temporary sessions                                  │
│     └── Performance optimization                            │
│     Capacity: 8192 entries (LRU eviction)                  │
│                                                             │
│  🏢 OAuth Client Store (__yao.oauth.client)                │
│     ├── Client registration data                            │
│     ├── Client credentials                                  │
│     ├── Redirect URIs                                       │
│     └── Client configuration                                │
│     Storage: {{ YAO_DATA_ROOT }}/stores/oauth/client        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Storage Responsibilities

| Layer            | Purpose                   | Data Lifetime | Performance | Backup Required |
| ---------------- | ------------------------- | ------------- | ----------- | --------------- |
| **Data Store**   | OAuth flow persistence    | Medium-term   | High        | ✅ Yes          |
| **Cache Store**  | High-speed temporary data | Short-term    | Very High   | ❌ No           |
| **Client Store** | Client credentials        | Long-term     | High        | ✅ Yes          |

### Directory Structure

```
{{ YAO_DATA_ROOT }}/
└── stores/
    └── oauth/
        ├── store/          # OAuth Data Store files
        └── client/         # OAuth Client Store files

Memory:
└── LRU Cache (8192 entries) # OAuth Cache Store
```

### Data Flow

1. **Client Registration** → Client Store (persistent)
2. **Authorization Flow** → Data Store (persistent) + Cache Store (temporary)
3. **Token Requests** → Cache Store (fast access) + Data Store (persistence)
4. **Token Validation** → Cache Store (first), Data Store (fallback)

---

## OAuth Configuration

### Required Configuration

#### `issuer_url`

- **Type**: `string`
- **Required**: Yes
- **Description**: OAuth token issuer URL for OAuth server
- **Usage**: Used as the `iss` claim in JWT tokens and issuer identifier

**Example:**

```json
"issuer_url": "https://localhost:5099"
```

---

## Signing Configuration

### Certificate Path Usage

All certificate paths in the signing configuration are **relative paths** that are resolved against the application's certificate directory structure:

```
{YAO_ROOT}/
├── openapi/
    └── certs/
        ├── signing-cert.pem          # Token signing certificate (public)
        ├── signing-key.pem           # Token signing private key
        ├── mtls-client-ca.pem        # mTLS client CA certificate
        └── ssl/                      # Optional subdirectories
            └── prod-cert.pem
```

**Path Resolution Rules:**

1. **Relative Paths**: Configured as relative to `{YAO_ROOT}/openapi/certs/`

   - Configuration: `"signing_cert_path": "signing-cert.pem"`
   - Resolved to: `{YAO_ROOT}/openapi/certs/signing-cert.pem`

2. **Subdirectory Support**: You can organize certificates in subdirectories

   - Configuration: `"signing_cert_path": "ssl/prod-cert.pem"`
   - Resolved to: `{YAO_ROOT}/openapi/certs/ssl/prod-cert.pem`

3. **Absolute Paths**: If you provide an absolute path, it will be used as-is
   - Configuration: `"signing_cert_path": "/etc/ssl/certs/oauth-cert.pem"`
   - Resolved to: `/etc/ssl/certs/oauth-cert.pem` (unchanged)

**Configuration Examples:**

```json
{
  "oauth": {
    "signing": {
      "signing_cert_path": "signing-cert.pem", // Simple filename
      "signing_key_path": "keys/signing-key.pem", // Subdirectory
      "mtls_client_ca_cert_path": "ca/client-ca.pem" // CA in subdirectory
    }
  }
}
```

**Directory Structure Example:**

```
/app/                                    # YAO_ROOT
├── openapi/
    ├── certs/
    │   ├── signing-cert.pem             # Referenced as "signing-cert.pem"
    │   ├── keys/
    │   │   └── signing-key.pem          # Referenced as "keys/signing-key.pem"
    │   └── ca/
    │       └── client-ca.pem            # Referenced as "ca/client-ca.pem"
    └── openapi.yao                      # Configuration file
```

**Benefits of This Approach:**

- 📁 **Clean Configuration**: Simple relative paths in configuration files
- 🔒 **Security**: Certificates organized in dedicated directory structure
- 🚀 **Portability**: Configurations work across different deployment environments
- 🛠️ **Maintainability**: Easy to locate and manage certificate files

### Required Fields

#### `signing_cert_path`

- **Type**: `string`
- **Required**: Yes
- **Description**: Relative path to token signing certificate (public key), resolved from `{YAO_ROOT}/openapi/certs/`
- **Usage**: Used for token verification
- **Example**: `"signing-cert.pem"` → `{YAO_ROOT}/openapi/certs/signing-cert.pem`

#### `signing_key_path`

- **Type**: `string`
- **Required**: Yes
- **Description**: Relative path to token signing private key, resolved from `{YAO_ROOT}/openapi/certs/`
- **Usage**: Used for token signing
- **Example**: `"signing-key.pem"` → `{YAO_ROOT}/openapi/certs/signing-key.pem`

### Optional Fields

#### `signing_key_password`

- **Type**: `string`
- **Required**: No
- **Default**: `""` (empty)
- **Description**: Password for encrypted private key

#### `signing_algorithm`

- **Type**: `string`
- **Required**: No
- **Default**: `RS256`
- **Options**: `RS256`, `RS384`, `RS512`, `ES256`, `ES384`, `ES512`
- **Description**: Token signing algorithm

#### `verification_certs`

- **Type**: `array[string]`
- **Required**: No
- **Default**: `[]` (empty)
- **Description**: Additional certificates for token verification

#### `mtls_client_ca_cert_path`

- **Type**: `string`
- **Required**: No
- **Description**: Relative path to CA certificate for mTLS client validation, resolved from `{YAO_ROOT}/openapi/certs/`
- **Example**: `"mtls-client-ca.pem"` → `{YAO_ROOT}/openapi/certs/mtls-client-ca.pem`

#### `mtls_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Enable mutual TLS authentication

#### `cert_rotation_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Enable automatic certificate rotation

#### `cert_rotation_interval`

- **Type**: `string` (duration)
- **Required**: No
- **Default**: `24h`
- **Description**: Certificate rotation interval
- **Format**: Go duration format (e.g., `1h`, `30m`, `24h`)

---

## Token Configuration

### Access Token Settings

#### `access_token_lifetime`

- **Type**: `string` (duration)
- **Required**: No
- **Default**: `1h`
- **Description**: Access token validity period
- **Format**: Go duration format

#### `access_token_format`

- **Type**: `string`
- **Required**: No
- **Default**: `jwt`
- **Options**: `jwt`, `opaque`
- **Description**: Access token format

#### `access_token_signing_alg`

- **Type**: `string`
- **Required**: No
- **Default**: `RS256`
- **Description**: Access token signing algorithm (JWT only)

### Refresh Token Settings

#### `refresh_token_lifetime`

- **Type**: `string` (duration)
- **Required**: No
- **Default**: `24h`
- **Description**: Refresh token validity period

#### `refresh_token_rotation`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Enable refresh token rotation for OAuth 2.1

#### `refresh_token_format`

- **Type**: `string`
- **Required**: No
- **Default**: `opaque`
- **Options**: `opaque`, `jwt`
- **Description**: Refresh token format

### Authorization Code Settings

#### `authorization_code_lifetime`

- **Type**: `string` (duration)
- **Required**: No
- **Default**: `10m`
- **Description**: Authorization code validity period

#### `authorization_code_length`

- **Type**: `integer`
- **Required**: No
- **Default**: `32`
- **Description**: Authorization code length in bytes

### Device Flow Settings

#### `device_code_lifetime`

- **Type**: `string` (duration)
- **Required**: No
- **Default**: `15m`
- **Description**: Device code validity period

#### `device_code_length`

- **Type**: `integer`
- **Required**: No
- **Default**: `8`
- **Description**: Device code length in bytes

#### `user_code_length`

- **Type**: `integer`
- **Required**: No
- **Default**: `8`
- **Description**: User code length for device flow

#### `device_code_interval`

- **Type**: `string` (duration)
- **Required**: No
- **Default**: `5s`
- **Description**: Device code polling interval

### Token Binding Settings

#### `token_binding_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Enable token binding to client certificates

#### `supported_binding_types`

- **Type**: `array[string]`
- **Required**: No
- **Default**: `["dpop", "mtls"]`
- **Options**: `dpop`, `mtls`
- **Description**: Supported token binding types

### Audience Settings

#### `default_audience`

- **Type**: `array[string]`
- **Required**: No
- **Default**: `[]` (empty)
- **Description**: Default token audience

#### `audience_validation_mode`

- **Type**: `string`
- **Required**: No
- **Default**: `strict`
- **Options**: `strict`, `relaxed`
- **Description**: Audience validation mode

---

## Security Configuration

### PKCE Settings

#### `pkce_required`

- **Type**: `boolean`
- **Required**: No
- **Default**: `true`
- **Description**: Require PKCE for OAuth 2.1 compliance

#### `pkce_code_challenge_method`

- **Type**: `array[string]`
- **Required**: No
- **Default**: `["S256"]`
- **Options**: `S256`, `plain`
- **Description**: Supported PKCE code challenge methods

#### `pkce_code_verifier_length`

- **Type**: `integer`
- **Required**: No
- **Default**: `128`
- **Description**: PKCE code verifier length

### State Parameter Settings

#### `state_parameter_required`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Require state parameter for CSRF protection

#### `state_parameter_lifetime`

- **Type**: `string` (duration)
- **Required**: No
- **Default**: `10m`
- **Description**: State parameter validity period

#### `state_parameter_length`

- **Type**: `integer`
- **Required**: No
- **Default**: `32`
- **Description**: State parameter length in bytes

### Rate Limiting

#### `rate_limit_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Enable rate limiting

#### `rate_limit_requests`

- **Type**: `integer`
- **Required**: No
- **Default**: `100`
- **Description**: Number of requests per window

#### `rate_limit_window`

- **Type**: `string` (duration)
- **Required**: No
- **Default**: `1m`
- **Description**: Rate limit time window

#### `rate_limit_by_client_id`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Enable per-client rate limiting

### Brute Force Protection

#### `brute_force_protection_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Enable brute force attack protection

#### `max_failed_attempts`

- **Type**: `integer`
- **Required**: No
- **Default**: `5`
- **Description**: Maximum failed login attempts

#### `lockout_duration`

- **Type**: `string` (duration)
- **Required**: No
- **Default**: `15m`
- **Description**: Account lockout duration

### Encryption Settings

#### `encryption_key`

- **Type**: `string`
- **Required**: No
- **Default**: `""` (empty)
- **Description**: Key for encrypting sensitive data

#### `encryption_algorithm`

- **Type**: `string`
- **Required**: No
- **Default**: `AES-256-GCM`
- **Description**: Encryption algorithm for sensitive data

### Network Security

#### `ip_whitelist`

- **Type**: `array[string]`
- **Required**: No
- **Default**: `[]` (empty)
- **Description**: IP addresses allowed to access

#### `ip_blacklist`

- **Type**: `array[string]`
- **Required**: No
- **Default**: `[]` (empty)
- **Description**: IP addresses blocked from access

#### `require_https`

- **Type**: `boolean`
- **Required**: No
- **Default**: `true`
- **Description**: Require HTTPS for all endpoints

#### `disable_unsecure_endpoints`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Disable non-HTTPS endpoints

---

## Client Configuration

### Default Client Settings

#### `default_client_type`

- **Type**: `string`
- **Required**: No
- **Default**: `confidential`
- **Options**: `confidential`, `public`
- **Description**: Default client type

#### `default_token_endpoint_auth_method`

- **Type**: `string`
- **Required**: No
- **Default**: `client_secret_basic`
- **Options**: `client_secret_basic`, `client_secret_post`, `client_secret_jwt`, `private_key_jwt`, `none`
- **Description**: Default client authentication method

#### `default_grant_types`

- **Type**: `array[string]`
- **Required**: No
- **Default**: `["authorization_code", "refresh_token"]`
- **Options**: `authorization_code`, `refresh_token`, `client_credentials`, `device_code`
- **Description**: Default supported grant types

#### `default_response_types`

- **Type**: `array[string]`
- **Required**: No
- **Default**: `["code"]`
- **Options**: `code`, `token`, `id_token`
- **Description**: Default supported response types

#### `default_scopes`

- **Type**: `array[string]`
- **Required**: No
- **Default**: `["openid", "profile", "email"]`
- **Description**: Default OAuth scopes

### Client Validation Settings

#### `client_id_length`

- **Type**: `integer`
- **Required**: No
- **Default**: `32`
- **Description**: Client ID length in bytes

#### `client_secret_length`

- **Type**: `integer`
- **Required**: No
- **Default**: `64`
- **Description**: Client secret length in bytes

#### `client_secret_lifetime`

- **Type**: `string` (duration)
- **Required**: No
- **Default**: `0s` (never expires)
- **Description**: Client secret lifetime

### Dynamic Registration

#### `dynamic_registration_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `true`
- **Description**: Enable dynamic client registration

#### `allowed_redirect_uri_schemes`

- **Type**: `array[string]`
- **Required**: No
- **Default**: `["https", "http"]`
- **Description**: Allowed redirect URI schemes

#### `allowed_redirect_uri_hosts`

- **Type**: `array[string]`
- **Required**: No
- **Default**: `["localhost", "127.0.0.1"]`
- **Description**: Allowed redirect URI hosts

### Client Certificate Settings

#### `client_certificate_required`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Require client certificates

#### `client_certificate_validation`

- **Type**: `string`
- **Required**: No
- **Default**: `none`
- **Options**: `none`, `optional`, `required`
- **Description**: Client certificate validation mode

---

## Features Configuration

### OAuth 2.1 Features

#### `oauth21_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `true`
- **Description**: Enable OAuth 2.1 features

#### `pkce_enforced`

- **Type**: `boolean`
- **Required**: No
- **Default**: `true`
- **Description**: Enforce PKCE for all clients

#### `refresh_token_rotation_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `true`
- **Description**: Enable refresh token rotation

### Advanced Flows

#### `device_flow_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `true`
- **Description**: Enable device authorization flow

#### `token_exchange_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Enable token exchange (RFC 8693)

#### `pushed_authorization_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Enable pushed authorization requests (RFC 9126)

#### `dynamic_client_registration_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `true`
- **Description**: Enable dynamic client registration (RFC 7591)

### Protocol Compliance

#### `mcp_compliance_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Enable MCP (Model Context Protocol) compliance

#### `resource_parameter_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Enable resource parameter support

### Security Features

#### `token_binding_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Enable token binding to client certificates

#### `mtls_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Enable mutual TLS authentication

#### `dpop_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Enable DPoP (Demonstration of Proof-of-Possession)

### Token Management

#### `jwt_introspection_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `true`
- **Description**: Enable JWT token introspection

#### `token_revocation_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `true`
- **Description**: Enable token revocation (RFC 7009)

#### `userinfo_jwt_enabled`

- **Type**: `boolean`
- **Required**: No
- **Default**: `false`
- **Description**: Enable JWT format for UserInfo responses

---

## Configuration Examples

### Minimal Configuration

```json
{
  "baseurl": "/v1",
  "store": "__yao.oauth.store",
  "cache": "__yao.oauth.cache",
  "providers": {
    "user": "__yao.user",
    "client": "__yao.oauth.client"
  },
  "oauth": {
    "issuer_url": "https://localhost:5099",
    "signing": {
      "signing_cert_path": "signing-cert.pem",
      "signing_key_path": "signing-key.pem"
    }
  }
}
```

### Production Configuration

```json
{
  "baseurl": "/v1",
  "store": "__yao.oauth.store",
  "cache": "__yao.oauth.cache",
  "providers": {
    "user": "__yao.user",
    "client": "__yao.oauth.client"
  },
  "oauth": {
    "issuer_url": "https://localhost:5099",
    "signing": {
      "signing_cert_path": "signing-cert.pem",
      "signing_key_path": "signing-key.pem",
      "mtls_enabled": true,
      "mtls_client_ca_cert_path": "mtls-client-ca.pem"
    },
    "token": {
      "access_token_lifetime": "30m",
      "refresh_token_rotation": true
    },
    "security": {
      "pkce_required": true,
      "rate_limit_enabled": true,
      "brute_force_protection_enabled": true,
      "require_https": true
    },
    "features": {
      "oauth21_enabled": true,
      "token_revocation_enabled": true,
      "jwt_introspection_enabled": true
    }
  }
}
```

### High-Security Configuration

```json
{
  "baseurl": "/v1",
  "store": "__yao.oauth.store",
  "cache": "__yao.oauth.cache",
  "providers": {
    "user": "__yao.user",
    "client": "__yao.oauth.client"
  },
  "oauth": {
    "issuer_url": "https://localhost:5099",
    "signing": {
      "signing_cert_path": "signing-cert.pem",
      "signing_key_path": "signing-key.pem",
      "mtls_enabled": true,
      "mtls_client_ca_cert_path": "mtls-client-ca.pem"
    },
    "token": {
      "access_token_lifetime": "15m",
      "refresh_token_rotation": true,
      "token_binding_enabled": true,
      "supported_binding_types": ["mtls", "dpop"]
    },
    "security": {
      "pkce_required": true,
      "state_parameter_required": true,
      "rate_limit_enabled": true,
      "brute_force_protection_enabled": true,
      "require_https": true,
      "disable_unsecure_endpoints": true
    },
    "client": {
      "client_certificate_required": true,
      "client_certificate_validation": "required"
    },
    "features": {
      "oauth21_enabled": true,
      "pkce_enforced": true,
      "mtls_enabled": true,
      "dpop_enabled": true,
      "token_binding_enabled": true,
      "pushed_authorization_enabled": true
    }
  }
}
```

---

## Best Practices

### Security Recommendations

1. **Always use HTTPS** in production
2. **Enable PKCE** for all clients
3. **Use short-lived access tokens** (15-30 minutes)
4. **Enable refresh token rotation**
5. **Implement rate limiting**
6. **Use mTLS** for high-security environments
7. **Enable brute force protection**
8. **Regularly rotate certificates**

### Performance Optimization

1. **Use opaque refresh tokens** for better revocation control
2. **Configure appropriate token lifetimes**
3. **Enable caching** for frequently accessed data
4. **Use JWT access tokens** for stateless validation
5. **Implement proper rate limiting**

### Monitoring and Logging

1. Enable comprehensive logging
2. Monitor token usage patterns
3. Track failed authentication attempts
4. Set up alerts for security events
5. Regularly audit client configurations

---

## Troubleshooting

### Common Issues

#### Certificate Problems

- Ensure certificate paths are correct
- Check certificate permissions
- Verify certificate validity dates
- Confirm certificate format (PEM)

#### Token Issues

- Check token lifetimes
- Verify signing algorithm compatibility
- Ensure proper audience configuration
- Confirm token format settings

#### Client Configuration

- Verify redirect URI configuration
- Check client authentication method
- Ensure proper grant type settings
- Confirm scope configuration

### Debug Mode

Enable debug logging by setting appropriate log levels in your Yao application configuration.

---

## RFC References

- [RFC 6749](https://tools.ietf.org/html/rfc6749) - OAuth 2.0 Authorization Framework
- [RFC 6750](https://tools.ietf.org/html/rfc6750) - OAuth 2.0 Bearer Token Usage
- [RFC 7009](https://tools.ietf.org/html/rfc7009) - OAuth 2.0 Token Revocation
- [RFC 7515](https://tools.ietf.org/html/rfc7515) - JSON Web Signature (JWS)
- [RFC 7517](https://tools.ietf.org/html/rfc7517) - JSON Web Key (JWK)
- [RFC 7519](https://tools.ietf.org/html/rfc7519) - JSON Web Token (JWT)
- [RFC 7523](https://tools.ietf.org/html/rfc7523) - JSON Web Token Profile for OAuth 2.0
- [RFC 7591](https://tools.ietf.org/html/rfc7591) - OAuth 2.0 Dynamic Client Registration
- [RFC 7636](https://tools.ietf.org/html/rfc7636) - PKCE for OAuth 2.0
- [RFC 8414](https://tools.ietf.org/html/rfc8414) - OAuth 2.0 Authorization Server Metadata
- [RFC 8693](https://tools.ietf.org/html/rfc8693) - OAuth 2.0 Token Exchange
- [RFC 8705](https://tools.ietf.org/html/rfc8705) - OAuth 2.0 Mutual-TLS Client Authentication
- [RFC 9126](https://tools.ietf.org/html/rfc9126) - OAuth 2.0 Pushed Authorization Requests
- [OAuth 2.1](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-v2-1) - OAuth 2.1 Authorization Framework
