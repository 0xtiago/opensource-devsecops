# Horusec v2.9.0-beta.3 - Static Analysis Security Test

- [Horusec - Static Analysis Security Test](#horusec---static-analysis-security-test)

  - [Scan Info](#scan-info)

  - [Tabela de Vulnerabilidades](#tabela-de-vulnerabilidades)

  - [Descrição das Vulnerabilidades](#descrição-das-vulnerabilidades)

## Scan Info

**Version:** v2.9.0-beta.3

**Status:** success

**CreatedAt:** 2024-07-22T19:07:43.491963638Z

**FinishedAt:** 2024-07-22T19:07:50.525841211Z

## Tabela de Vulnerabilidades

| Severity | Rule ID | Sumário | Arquivo:Linha | Ferramenta de Segurança |
| --- | --- | --- | --- | --- |
| 🟣 Critical | HS-LEAKS-25 | Potential Hard-coded credential | config.py:12 | HorusecEngine |
| 🟣 Critical | HS-LEAKS-25 | Potential Hard-coded credential | models/user_model.py:48 | HorusecEngine |
| 🟣 Critical | HS-LEAKS-26 | Hard-coded password | api_views/users.py:183 | HorusecEngine |
| 🔴 High | 62142 |  Versions Unsafes: <3.0 | /src/horusec/requirements.txt:1 | Safety |
| 🔴 High | 55261 |  Versions Unsafes: <2.2.5 | /src/horusec/requirements.txt:2 | Safety |
| 🔴 High |  | MissConfiguration | Dockerfile:0 | Trivy |
| 🔴 High | CVE-2023-30861 | Flask is a lightweight WSGI web application framework. When all of the following conditions are met, a response containing data intended for one client may be cached and subsequently sent by the proxy to other clients. If the proxy also caches `Set-... | requirements.txt:2 | Trivy |
| 🟡 Medium | B104 | Possible binding to all interfaces. | app.py:17 | Bandit |
| 🟡 Medium | B608 | Possible SQL injection vector through string-based query construction. | models/user_model.py:72 | Bandit |

## Descrição das Vulnerabilidades

### 🟣 Potential Hard-coded credential

**Severidade:**  🟣 Critical

**Sumário:** **Potential Hard-coded credential**

**Descrição:** The software contains hard-coded credentials, such as a password or cryptographic key, which it uses for its own inbound authentication, outbound communication to external components, or encryption of internal data. For more information checkout the CWE-798 (https://cwe.mitre.org/data/definitions/798.html) advisory.

**Arquivo:** config.py:12

**Código:** `vuln_app.app.config['SECRET_KEY'] = 'random'`

**Ferramenta de Segurança:** HorusecEngine


---

### 🟣 Potential Hard-coded credential

**Severidade:**  🟣 Critical

**Sumário:** **Potential Hard-coded credential**

**Descrição:** The software contains hard-coded credentials, such as a password or cryptographic key, which it uses for its own inbound authentication, outbound communication to external components, or encryption of internal data. For more information checkout the CWE-798 (https://cwe.mitre.org/data/definitions/798.html) advisory.

**Arquivo:** models/user_model.py:48

**Código:** `payload = jwt.decode(auth_token, vuln_app.app.config.get('SECRET_KEY'), algorithms=["HS256"])`

**Ferramenta de Segurança:** HorusecEngine


---

### 🟣 Hard-coded password

**Severidade:**  🟣 Critical

**Sumário:** **Hard-coded password**

**Descrição:** The software contains hard-coded credentials, such as a password or cryptographic key, which it uses for its own inbound authentication, outbound communication to external components, or encryption of internal data. For more information checkout the CWE-798 (https://cwe.mitre.org/data/definitions/798.html) advisory.

**Arquivo:** api_views/users.py:183

**Código:** `'Password': 'Updated.'`

**Ferramenta de Segurança:** HorusecEngine


---

### 🔴  Versions Unsafes: <3.0

**Severidade:**  🔴 High

**Sumário:** ** Versions Unsafes: <3.0**

**Descrição:** More Information: Connexion 3.0 updates its dependency 'httpx' to include a security fix.

**Arquivo:** /src/horusec/requirements.txt:1

**Código:** `connexion[swagger-ui]==2.14.2`

**Ferramenta de Segurança:** Safety


---

### 🔴  Versions Unsafes: <2.2.5

**Severidade:**  🔴 High

**Sumário:** ** Versions Unsafes: <2.2.5**

**Descrição:** More Information: Flask 2.2.5 and 2.3.2 include a fix for CVE-2023-30861: When all of the following conditions are met, a response containing data intended for one client may be cached and subsequently sent by the proxy to other clients. If the proxy also caches 'Set-Cookie' headers, it may send one client's 'session' cookie to other clients. The severity depends on the application's use of the session and the proxy's behavior regarding cookies. The risk depends on all these conditions being met:
1. The application must be hosted behind a caching proxy that does not strip cookies or ignore responses with cookies.
2. The application sets 'session.permanent = True'
3. The application does not access or modify the session at any point during a request.
4. 'SESSION_REFRESH_EACH_REQUEST' enabled (the default).
5. The application does not set a 'Cache-Control' header to indicate that a page is private or should not be cached.
This happens because vulnerable versions of Flask only set the 'Vary: Cookie' header when the session is accessed or modified, not when it is refreshed (re-sent to update the expiration) without being accessed or modified.
https://github.com/pallets/flask/security/advisories/GHSA-m2qf-hxjv-5gpq

**Arquivo:** /src/horusec/requirements.txt:2

**Código:** `flask==2.2.2`

**Ferramenta de Segurança:** Safety


---

### 🔴 MissConfiguration

**Severidade:**  🔴 High

**Sumário:** **MissConfiguration**

**Descrição:**       Running containers with 'root' user can lead to a container escape situation. It is a best practice to run containers as non-root users, which can be done by adding a 'USER' statement to the Dockerfile.
      Message: Specify at least 1 USER command in Dockerfile with non-root user as argument
      Resolution: Add 'USER <non root user name>' line to the Dockerfile
      References: [https://docs.docker.com/develop/develop-images/dockerfile_best-practices/ https://avd.aquasec.com/appshield/ds002]

**Arquivo:** Dockerfile:0

**Código:** `root user`

**Ferramenta de Segurança:** Trivy


---

### 🔴 Flask is a lightweight WSGI web application framework. When all of the following conditions are met,...

**Severidade:**  🔴 High

**Sumário:** **Flask is a lightweight WSGI web application framework. When all of the following conditions are met, a response containing data intended for one client may be cached and subsequently sent by the proxy to other clients. If the proxy also caches `Set-Cookie` headers, it may send one client's `session` cookie to other clients. The severity depends on the application's use of the session and the proxy's behavior regarding cookies. The risk depends on all these conditions being met.1. The application must be hosted behind a caching proxy that does not strip cookies or ignore responses with cookies.**

**Descrição:** 2. The application sets `session.permanent = True`
3. The application does not access or modify the session at any point during a request.
4. `SESSION_REFRESH_EACH_REQUEST` enabled (the default).
5. The application does not set a `Cache-Control` header to indicate that a page is private or should not be cached.This happens because vulnerable versions of Flask only set the `Vary: Cookie` header when the session is accessed or modified, not when it is refreshed (re-sent to update the expiration) without being accessed or modified. This issue has been fixed in versions 2.3.2 and 2.2.5.
PrimaryURL: https://avd.aquasec.com/nvd/cve-2023-30861.
Cwe Links: (https://cwe.mitre.org/data/definitions/539.html)

**Arquivo:** requirements.txt:2

**Código:** `flask==2.2.2
	Installed Version: "2.2.2"
	Update to Version: "2.3.2, 2.2.5" for fix this issue.`

**Ferramenta de Segurança:** Trivy


---

### 🟡 Possible binding to all interfaces.

**Severidade:**  🟡 Medium

**Sumário:** **Possible binding to all interfaces.**

**Descrição:** 

**Arquivo:** app.py:17

**Código:** `16 if __name__ == '__main__':
17     vuln_app.run(host='0.0.0.0', port=5000, debug=True)
`

**Ferramenta de Segurança:** Bandit


---

### 🟡 Possible SQL injection vector through string-based query construction.

**Severidade:**  🟡 Medium

**Sumário:** **Possible SQL injection vector through string-based query construction.**

**Descrição:** 

**Arquivo:** models/user_model.py:72

**Código:** `71         if vuln:  # SQLi Injection
72             user_query = f"SELECT * FROM users WHERE userna`

**Ferramenta de Segurança:** Bandit


---

