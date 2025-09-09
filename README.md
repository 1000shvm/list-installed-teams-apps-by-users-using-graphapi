# Teams Installed Apps Audit Script

## 📄 Overview
This PowerShell script retrieves the list of **installed Teams apps by users** in a Microsoft 365 tenant using **Microsoft Graph API**.  
It can be used for **auditing external app installations** in Teams and making informed policy decisions — for example, **blocking new external apps** while still allowing access for users who already use them, preventing disruption in the organization.

---

## 🚀 Purpose
- Get a complete mapping of **which Teams apps are installed by which users**.
- Identify **external or unapproved apps** in use.
- Support **policy enforcement** by allowing exceptions for existing users.
- Export results to **CSV** for reporting and further analysis.

---

## 🛠️ How It Works
1. **Authentication**  
   - Uses client credentials flow (`clientId`, `clientSecret`, `tenantId`) to authenticate against Microsoft Graph API.  
   - Obtains an OAuth token for API calls.  

2. **User and App Retrieval**  
   - Retrieves all users from the tenant.  
   - For each user (with a valid email), fetches their installed Teams apps.  
   - Builds a user → apps mapping.  

3. **Data Transformation**  
   - Saves intermediate results as JSON for reuse.  
   - Reverses mapping to app → users.  

4. **Export**  
   - Exports the final results to a CSV file with columns:  
     - **TeamsAppId** → App display name  
     - **Users** → Comma-separated list of user emails  

---

## 📦 Output Files
- **JSON File** → Intermediate storage of user-to-app mapping.  
- **CSV File** → Final export containing app-to-user mapping for reporting.  

---

## ✅ Prerequisites
- Microsoft 365 tenant with Teams enabled.  
- App Registration in Azure AD with permissions:  
  - `User.Read.All`  
  - `TeamworkAppSettings.Read` (or equivalent Teams app permissions).  
- PowerShell 5.1+ or PowerShell Core installed.  
- Graph API access enabled.  

---

## ⚙️ Usage
1. Update the script with your tenant ID, client ID, and client secret:  
   - `$tenantId = "<your-tenant-id>"`  
   - `$clientId = "<your-client-id>"`  
   - `$clientSecret = "<your-client-secret>"`  

2. Run the script in PowerShell.  
3. Find results in the exported CSV file, for example:  
   `C:\Users\<YourUser>\OneDrive - <OrgName>\FinalAppUserListMYtestiddd.csv`  

---

## 📧 Use Cases
- Audit external Teams apps usage in the organization.  
- Allow exceptions for existing users when tightening Teams policies.  
- Generate reports for security and compliance reviews.  

---

## 🔗 References
- [Microsoft Graph API – TeamsApp Installation](https://learn.microsoft.com/en-us/graph/api/resources/teamsappinstallation?view=graph-rest-1.0)  
- [Microsoft Graph Authentication](https://learn.microsoft.com/en-us/graph/auth-v2-service)  

---

## 📝 Author
Prepared as part of an audit and governance solution for Microsoft Teams.
