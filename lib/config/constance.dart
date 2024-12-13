import 'package:expense_app/domain/entities/day_of_week.dart';

const exchangeRate = 4000;
enum DataStatus { LOADING, QUERY_MORE, COMPLETED, EMPTY }
enum PaymentStatus { PENDING, ACTIVE, INACTIVE, EXPIRED, CANCEL }
enum AdsSource { FACEBOOK, GOOGLE }

const privacyUrl = "https://expense.cam2know.com/en/privacy-policy";
const webUrl = "https://expense.cam2know.com";
const fbUrl = "https://www.facebook.com/100Expense";
const apiUrl = "https://expense-api-nly3.onrender.com/api/v1/";
// const apiUrl = "http://119.13.109.238:8000/api/v1/";
// const apiUrl = "http://192.168.4.139:8000/api/v1/";
const defaultSize = 10;
List<DayOfWeek> dayOfWeek = [
  DayOfWeek(en: "Monday", kh: "ច័ន្ទ"),
  DayOfWeek(en: "Tuesday", kh: "អង្គារ"),
  DayOfWeek(en: "Wednesday", kh: "ពុធ"),
  DayOfWeek(en: "Thursday", kh: "ព្រហស្បតិ៍"),
  DayOfWeek(en: "Friday", kh: "សុក្រ"),
  DayOfWeek(en: "Saturday", kh: "សៅរ៍"),
  DayOfWeek(en: "Sunday", kh: "អាទិត្យ"),
];
