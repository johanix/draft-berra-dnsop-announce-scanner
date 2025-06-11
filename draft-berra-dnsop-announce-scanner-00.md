Abstract

In DNS operations, automated scanners are commonly employed to detect the presence of specific records, such as CDS or CSYNC, indicating a desire for delegation updates. However, the presence and periodicity of these scanners are typically implicit and undocumented, leading to inefficiencies and uncertainties. ￼

This document proposes an extension to the DSYNC resource record, as defined in [draft-ietf-dnsop-generalized-notify], allowing parent zones to explicitly signal the presence and scanning interval of such automated scanners. This enhancement aims to improve transparency and coordination between child and parent zones. ￼

Status of This Memo

This Internet-Draft is submitted in full conformance with the provisions of BCP 78 and BCP 79.

Internet-Drafts are working documents of the Internet Engineering Task Force (IETF). Note that other groups may also distribute working documents as Internet-Drafts. The list of current Internet-Drafts is at https://datatracker.ietf.org/drafts/current/.

This Internet-Draft will expire on 4 December 2025. ￼

1. Introduction

Automated scanners play a vital role in DNS operations by monitoring zones for specific records that signal desired updates to delegation information. For instance, the presence of CDS records in a child zone indicates a request to update DS records in the parent zone. However, the operation of these scanners is often opaque, with no standardized method for child zones to signal their presence or scanning frequency. ￼

The lack of explicit signaling can lead to inefficiencies, such as unnecessary scanning or delayed updates due to misaligned expectations between child and parent zones. To address this, we propose an extension to the DSYNC resource record, enabling child zones to explicitly communicate the presence and scanning interval of their automated scanners.

2. DSYNC Record Extension for Scanner Signaling

The DSYNC resource record, as defined in [draft-ietf-dnsop-generalized-notify], facilitates the discovery of endpoints for generalized NOTIFY messages. We propose an extension to this record to signal scanner presence and periodicity.

The DSYNC record has the following format: ￼

{owner} IN DSYNC {RRtype} {scheme} {port} {target}

For scanner signaling, the fields are interpreted as follows:
	•	owner: The domain name of the child zone.
	•	RRtype: The type of record the scanner is monitoring (e.g., CDS, CSYNC). ￼
	•	scheme: Set to 1, indicating a NOTIFY message.
	•	port: Overloaded to represent the scanning interval in minutes. ￼
	•	target: Set to “.”, indicating that this record is for scanner signaling purposes.

2.1 Signaling Scanner Presence

To signal the presence of a scanner that checks for CDS records every 60 minutes, a child zone would publish the following DSYNC record: ￼

example.com. IN DSYNC CDS 1 60 .

This record informs the parent zone that the child zone operates a scanner for CDS records with a 60-minute interval. ￼


2.2 Signaling Absence of a Scanner

To explicitly signal the absence of a scanner, the child zone would set the port field to 0:
example.com. IN DSYNC CDS 1 0 .

This record indicates that the child zone does not operate a scanner for CDS records.

3. Operational Considerations

Implementing this extension requires coordination between child and parent zones. Child zones should ensure that the DSYNC records accurately reflect their scanner operations. Parent zones may use this information to adjust their expectations and processes accordingly.

It’s important to note that overloading the port field for scanner interval signaling deviates from its original purpose. Implementers should handle this overloading with care to avoid conflicts with existing uses of the port field.

4. Security Considerations

The proposed extension does not introduce new security vulnerabilities. However, as with any DNS record, authenticity and integrity should be ensured through DNSSEC signing. Parent zones should validate the DSYNC records using DNSSEC to prevent spoofing or tampering.

5. IANA Considerations

This document does not require any IANA actions. ￼

6. References

6.1 Normative References
	•	[draft-ietf-dnsop-generalized-notify] Generalized DNS Notifications. ￼

6.2 Informative References
	•	[draft-johani-dnsop-delegation-mgmt-via-ddns] Automating DNS Delegation Management via DDNS. ￼
