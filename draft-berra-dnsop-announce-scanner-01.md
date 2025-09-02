---
title: "Announce Existence of Parent CDS/CSYNC Scanner"
abbrev: "Announce Parent DNS Scanner"
docname: draft-berra-dnsop-announce-scanner-01
date: {DATE}
category: std

ipr: trust200902
area: Internet
workgroup: DNSOP Working Group
keyword: Internet-Draft

stand_alone: yes
pi: [toc, sortrefs, symrefs]

author:
 -
  ins: E. Bergström
  name: Erik Bergström
  organization: The Swedish Internet Foundation
  country: Sweden
  email: erik.bergstrom@internetstiftelsen.se
 -
  ins: J. Stenstam
  name: Johan Stenstam
  organization: The Swedish Internet Foundation
  country: Sweden
  email: johan.stenstam@internetstiftelsen.se
 -
  ins: L. Fernandez
  name: Leon Fernandez
  organization: The Swedish Internet Foundation
  country: Sweden
  email: leon.fernandez@internetstiftelsen.se

normative:

informative:

--- abstract

In DNS operations, automated scanners are commonly employed by the
operator of a parent zone to detect the presence of specific records,
such as CDS or CSYNC, in child zones, indicating a desire for
delegation updates. However, the presence and periodicity of these
scanners are typically implicit and undocumented, leading to
inefficiencies and uncertainties. ￼

This document proposes an extension to the semantics of the DSYNC
resource record, as defined in
draft-ietf-dnsop-generalized-notify, allowing parent zones to
explicitly signal the presence and scanning interval of such automated
scanners. This enhancement aims to improve transparency and
coordination between child and parent zones.

TO BE REMOVED: This document is being collaborated on in Github at:
[https://github.com/johanix/draft-berra-dnsop-announce-scanner](https://github.com/johanix/draft-berra-dnsop-announce-scanner).
The most recent working version of the document, open issues, etc,
should all be available there.  The authors (gratefully) accept pull
requests.

--- middle

# Introduction

Automated scanners play a vital role in DNS operations by monitoring
zones for specific records that signal desired updates to delegation
information. For instance, the presence of CDS records in a child zone
indicates a request to update DS records in the parent zone. However,
the operation of these scanners is often opaque, with no standardized
method for parent zones to signal their presence or scanning
frequency. ￼

The lack of explicit signaling can lead to inefficiencies, such as
unnecessary scanning or delayed updates due to misaligned expectations
between child and parent zones. To address this, this document
proposes an extension to the semantics of the DSYNC resource record,
enabling parent zones to explicitly announce the presence and scanning
interval of their automated scanners.

As the DSYNC record becomes standard automated child-side systems
looking up the parent DSYNC records are expected. Given that a vast
majority of parent zones do not operate scanners providing a simple
mechaism to inform the child of this fact will be useful.

# Requirements Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in {{!RFC2119}}.

# DSYNC Record Extension for Scanner Signaling

The DSYNC resource record, as defined in
{{?I-D.draft-ietf-dnsop-generalized-notify}}, facilitates the
discovery of endpoints for generalized NOTIFY messages. This document
proposes a new {scheme} for this record that can be used to signal
scanner presence (or absence) and periodicity. This new scheme=3 is
defined as "SCANNER".

The DSYNC record has the following format, as defined in
{{?I-D.draft-ietf-dnsop-generalized-notify}}:

{owner} IN DSYNC {RRtype} {Scheme} {Port} {Target}

For scanner signaling, the fields are interpreted as follows:

  * owner: The name of the parent zone. Follows the discovery methods
       specified in the DSYNC specification.

  * RRtype: The type of record the scanner is monitoring (e.g., CDS,
       CSYNC).

  * Scheme: Set to SCANNER (on the wire this is represented as a uint8
       = 3).

  * Port: Overloaded to represent the scanning interval in minutes.

  * Target: Not used, RECOMMENDED to set to ".".

## Signaling Scanner Presence

To signal the presence of a scanner that check for CDS and CSYNC records
once every 24 hours, a parent zone would publish the following DSYNC
records:

_dsync.parent.example. IN DSYNC CDS SCANNER 1440 .
_dsync.parent.example. IN DSYNC CSYNC SCANNER 1440 .

The presence of these records informs the child operator that the parent
zone operates a scanner for both CDS and CSYNC records with a 1440-minute
(= 24h) interval.

## Signaling Absence of a Scanner

To explicitly signal the absence of a scanner, the parent zone would
set the port field to 0:

_dsync.parent.example. IN DSYNC CDS SCANNER 0 .
_dsync.parent.example. IN DSYNC CSYNC SCANNER 0 .

The presence of these records indicate that the parent zone does not
operate a scanner for CDS or CSYNC records.

## Wildcard and Child-specific Methods

Parent zones can also use the wildcard and child-specific methods
to signal the presence or absence of scanners as described in
{{?I-D.draft-ietf-dnsop-generalized-notify}}.

For example:

*._dsync.parent.example. IN DSYNC CDS SCANNER 0 .
*._dsync.parent.example. IN DSYNC CSYNC SCANNER 0 .

or

child._dsync.parent.example. IN DSYNC CDS SCANNER 0 .
child._dsync.parent.example. IN DSYNC CSYNC SCANNER 0 .



# Operational Considerations

Publishing DSYNC records (typically for both CDS and CSYNC records)
requires no coordination between parent and child zones. The parent
zone operator should ensure that the DSYNC records accurately reflect
their scanner operations (or absence of a scanner). Child zone
operators may use this information to adjust their expectations and
processes accordingly.

It's important to note that overloading the port field for scanner
interval signaling deviates from its original purpose. Using a new
{scheme}, "SCANNER", is intended to minimize the implications of this
as software implementations SHOULD discard any unsupported schemes.

# Security Considerations

The proposed new DSYNC scheme does not introduce new security
vulnerabilities. As in {{?I-D.draft-ietf-dnsop-generalized-notify}}
use of DNSSEC is RECOMMENDED but not required. Hence, a child service
that looks up DSYNC RRsets in the parent zone may choose to ignore
unsigned DSYNC RRsets.

# IANA Considerations

IANA is requested to assign a new "scheme" value to the registry for
"DSYNC Location of Synchronization Endpoints" as follows:

Reference  (this document)

~~~
+========+========+==========+======================+=================+
| RRtype | Scheme | Mnemonic | Purpose              | Reference       |
+========+========+==========+======================+=================+
| CDS    | 3      | SCANNER  | Scanner announcement | (this document) |
+--------+--------+----------+----------------------+-----------------+
| CSYNC  | 3      | SCANNER  | Scanner announcement | (this document) |
+--------+--------+----------+----------------------+-----------------+
~~~

--- back

# Change History (to be removed before publication)

> Initial public draft
> Make sure examples use _dsync label and propose new scheme
