# CU Core Configuration SDK

A tokenized, **1033-compliant** configuration SDK for credit union core banking adapters with a **Teenage Engineering-style** UI.

## Features

- **7-Step Configuration Wizard** - Core selection, connection, credentials, compliance, payment rails, field mapping, confirmation
- **1033 Compliance Built-in** - Every API response includes compliance status metadata
- **Compliance Dashboard** - Real-time status monitoring for all 14 monetary services
- **Tokenized Configuration** - Secure, encrypted storage of sensitive adapter credentials
- **Payment Rails Support** - ACH, Wire, RTP, and FedNow configuration
- **Teenage Engineering Design** - Industrial minimal aesthetic with Geist font

## Supported Core Systems

| Core System | Vendor | Protocol | Compliance |
|-------------|--------|----------|------------|
| Symitar | Jack Henry | PowerOn | KYC, ACH, Wire |
| Fiserv DNA | Fiserv | SOAP | KYC, SOAP, ACH, Wire |
| Corelation KeyStone | Corelation | REST/OAuth | KYC, AML, ACH, Wire |
| Jack Henry Digital | Jack Henry | REST/OAuth | OAuth, ACH, Wire |
| Episys | Symitar | PowerOn | PowerOn, ACH, Wire |
| FedNow | Federal Reserve | ISO 20022 | 1033, FedNow |
| Generic | Custom | REST/SOAP | Configurable |

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  cu_core_config_sdk:
    path: ../cu_core_config_sdk
```

## Quick Start

### Configuration Wizard

```dart
import 'package:cu_core_config_sdk/cu_core_config_sdk.dart';

CoreConfigWizard(
  supabaseUrl: 'https://your-project.supabase.co',
  supabaseKey: 'your-anon-key',
  tenantId: 'your-tenant-id',
  onComplete: (config) {
    print('Configuration saved: ${config.coreSystem}');
  },
  onCancel: () {
    print('Wizard cancelled');
  },
)
```

### Compliance Dashboard

```dart
ComplianceDashboard(
  supabaseUrl: 'https://your-project.supabase.co',
  supabaseKey: 'your-anon-key',
  tenantId: 'your-tenant-id',
  onConfigurePressed: () {
    // Navigate to wizard
  },
)
```

### Fetch Compliance Status Programmatically

```dart
complianceService.initialize(
  supabaseUrl: 'https://your-project.supabase.co',
  supabaseKey: 'your-anon-key',
  tenantId: 'your-tenant-id',
);

final status = await complianceService.getStatus();
print('Overall score: ${status.overallScore}');
print('1033 Compliant: ${status.is1033Compliant}');
```

## 1033 Compliance

Every API response includes compliance metadata:

```json
{
  "data": { ... },
  "compliance": {
    "1033_status": "COMPLIANT",
    "fdx_version": "5.0",
    "data_rights": ["ACCESS", "PORTABILITY", "DELETION"],
    "consent_required": true,
    "audit_id": "uuid"
  }
}
```

## Theme

The SDK uses the Teenage Engineering design language:

- **Font:** Geist (regular weights, NO mono)
- **Colors:** Pure black `#000` / white `#FFF` / zinc `#27272A`
- **Style:** Industrial minimal, dense information, thin borders

```dart
// Access theme constants
TETheme.background  // #000000
TETheme.surface     // #0A0A0A
TETheme.border      // #27272A
TETheme.text        // #FFFFFF
TETheme.success     // #22C55E
TETheme.error       // #EF4444
TETheme.warning     // #F59E0B
```

## Wizard Steps

1. **Core Selection** - Choose Symitar, Fiserv, Corelation, Jack Henry, FedNow, etc.
2. **Connection** - API URL, Device ID, Institution ID, Environment
3. **Credentials** - Bearer token, OAuth, Basic auth, Certificate
4. **Compliance** - 1033, KYC, AML, BSA, OFAC toggles + FDX version
5. **Payment Rails** - ACH, Wire, RTP, FedNow configuration
6. **Field Mapping** - Account/transaction type mappings
7. **Confirmation** - Connection test + compliance score

## Database Schema

The SDK requires these Supabase tables:

- `service_compliance` - Per-service 1033/KYC/AML status
- `consent_records` - Consumer consent audit trail (1033 required)
- `core_adapter_tokens` - Tokenized adapter configurations
- `adapter_config_schemas` - Wizard step definitions

## Edge Functions

Deploy these Supabase Edge Functions:

- `compliance-status` - Real-time compliance dashboard data
- `resolve-adapter-config` - Fetch tokenized config + compliance
- `test-adapter-connection` - Test + validate 1033 compliance
- `save-adapter-config` - Save wizard config + update compliance

## License

Proprietary - All rights reserved
