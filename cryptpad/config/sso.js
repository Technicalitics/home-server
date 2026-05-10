// SPDX-FileCopyrightText: 2023 XWiki CryptPad Team <contact@cryptpad.org> and contributors
//
// SPDX-License-Identifier: AGPL-3.0-or-later

//const fs = require('node:fs');
module.exports = {
    // Enable SSO login on this instance
    enabled: true,
    // Block registration for non-SSO users on this instance
    enforced: true,
    // Allow users to add an additional CryptPad password to their SSO account
    cpPassword: false,
    // You can also force your SSO users to add a CryptPad password
    forceCpPassword: false,
    // List of SSO providers
    list: [
	    {
		name: 'Authentik',
		type: 'oidc',
		url: 'https://auth.YOUR-TAILNET.ts.net/application/o/cryptpad/',
		client_id: "id",
		client_secret: "secret"
	    }
    ]
};
