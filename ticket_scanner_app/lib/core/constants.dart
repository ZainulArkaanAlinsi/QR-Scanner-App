// ---------------------------------------------------------------------------
// Change kBaseUrl based on how you run the app:
//   Emulator Android : http://10.0.2.2:8000/api
//   Physical device  : http://<YOUR_PC_LAN_IP>:8000/api  e.g. http://192.168.1.5:8000/api
//   Production       : https://your-domain.com/api
// ---------------------------------------------------------------------------
const String kAppName = 'TicketScan';
const String kBaseUrl = 'http://10.0.2.2:8000/api';

// SharedPreferences keys
const String kTokenKey = 'auth_token';
const String kUserKey = 'auth_user';

// User roles
const String kRoleAdmin = 'admin';
const String kRoleAttendee = 'attendee';
