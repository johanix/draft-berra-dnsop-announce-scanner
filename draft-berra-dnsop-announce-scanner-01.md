---
title: "Announce Existence of Parent CDS/CSYNC Scanner"
abbrev: "Announce Parent DNS Scanner"
docname: draft-berra-dnsop-announce-scanner-00
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
{{?I-D.draft-ietf-dnsop-generalized-notify}}, allowing parent zones to
explicitly signal the presence and scanning interval of such automated
scanners. This enhancement aims to improve transparency and
coordination between child and parent zones.

TO BE REMOVED: This document is being collaborated on in Github at:
[https://github.com/johanix/draft-berra-dnsop-announce-scanner](https://github.com/johanix/draft-berra-dnsop-announce-scanner).
The most recent working version of the document, open issues, etc, should all be
available there.  The authors (gratefully) accept pull requests.

--- middle

# **1. Introduction**

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

# **2. DSYNC Record Extension for Scanner Signaling**

The DSYNC resource record, as defined in
{{?I-D.draft-ietf-dnsop-generalized-notify}}, facilitates the
discovery of endpoints for generalized NOTIFY messages. This document
proposes an extension to the semantics this record to signal scanner
presence (or absence) and periodicity.

The DSYNC record has the following format, as defined in
{{?I-D.draft-ietf-dnsop-generalized-notify}}:

{owner} IN DSYNC {RRtype} {Scheme} {Port} {Target}

where {owner} follows the discovery methods specified in the DSYNC specification.

For scanner signaling, the fields are interpreted as follows:

  * owner: The name of the parent zone.

  * RRtype: The type of record the scanner is monitoring (e.g., CDS,
       CSYNC).

  * Scheme: Set to NOTIFY (on the wire this is represented as a uint8
       = 1).

  * Port: Overloaded to represent the scanning interval in minutes.

  * Target: Set to ".", indicating that this record is for scanner
       signaling purposes.

## **2.1 Signaling Scanner Presence**

To signal the presence of a scanner that check for CDS and CSYNC records
once every 24 hours, a parent zone would publish the following DSYNC
records:

_dsync.parent.example. IN DSYNC CDS NOTIFY 1440 .
_dsync.parent.example. IN DSYNC CSYNC NOTIFY 1440 .

The presence of these records informs the child operator that the parent
zone operates a scanner for both CDS and CSYNC records with a 1440-minute
(= 24h) interval.

## **2.2 Signaling Absence of a Scanner**

To explicitly signal the absence of a scanner, the parent zone would
set the port field to 0:

_dsync.parent.example. IN DSYNC CDS NOTIFY 0 .
_dsync.parent.example. IN DSYNC CSYNC NOTIFY 0 .

The presence of these records indicate that the parent zone does not
operate a scanner for CDS or CSYNC records.

## **2.3 Wildcard and Child-specific Methods**

Parent zones can also use the wildcard and child-specific methods to signal
the presence or absence of scanners as described in {{?I-D.draft-ietf-dnsop-generalized-notify}}.

For example:

*._dsync.parent.example. IN DSYNC CDS NOTIFY 0 .
*._dsync.parent.example. IN DSYNC CSYNC NOTIFY 0 .

or

child._dsync.parent.example. IN DSYNC CDS NOTIFY 0 .
child._dsync.parent.example. IN DSYNC CSYNC NOTIFY 0 .



# **3. Operational Considerations**

Publishing DSYNC records (typically for both CDS and CSYNC records)
requires no coordination between parent and child zones. The parent
zone operator should ensure that the DSYNC records accurately reflect
their scanner operations (or absence of a scanner). Child zone
operators may use this information to adjust their expectations and
processes accordingly.

It's important to note that overloading the port field for scanner
interval signaling deviates from its original purpose. Hence it is
important to first verify that the DSYNC Target field is equivalent to
"." before interpreting the Port field as a signaling mechanism rather
than a port number.

# **4. Security Considerations**

The proposed semantic extension does not introduce new security
vulnerabilities. However, as with any DNS record, authenticity and
integrity should be ensured through DNSSEC signing. Child zones
operators should validate the DSYNC records using DNSSEC before
trusting them.

# **5. IANA Considerations**

This document does not require any IANA actions.

--- back

# Change History (to be removed before publication)

> Initial public draft
