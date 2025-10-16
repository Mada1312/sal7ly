import 'package:get/get.dart';

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'Sal7ly': 'Sal7ly',
      'Request Technician': 'Request Technician',
      'Account Settings': 'Account Settings',
      'Settings': 'Settings',
      'Log Out': 'Log Out',
      'Menu': 'Menu',
      'Electrician': 'Electrician',
      'Plumber': 'Plumber',
      'Painter': 'Painter',
      'Carpenter': 'Carpenter',
      'AC Technician': 'AC Technician',

      // Account settings
      'Personal Information': 'Personal Information',
      'Saved Address': 'Saved Address',
      'Email': 'Email',
      'Saved Cards': 'Saved Cards',
      'Notifications': 'Notifications',
      'Delete Account': 'Delete Account',
      'Change Language': 'Change Language',
      'English': 'English',
      'Arabic': 'Arabic',

      // Request flow
      'Searching for': 'Searching for :service',
      'Looking for nearest': 'Looking for nearest :service...',
      'seconds remaining': 'seconds remaining',
      'Cancel Request': 'Cancel Request',
      'Technician Assigned': 'Technician Assigned',
      'Name': 'Name',
      'Phone': 'Phone Number',
      'Rating': 'Rating',
      'Arrival Time': 'Arrival Time',
      'min': 'min',
      'minutes': 'minutes',
      'OK': 'OK',
      'Request Timeout': 'Request Timeout',
      'No technician found.': 'No technician found.',
      'Incomplete user data': 'Incomplete user data',

      // Notifications Page
      'Notifications settings coming soon...':
          'Notifications settings coming soon...',

      // Saved Cards Page
      'This feature is coming soon...': 'This feature is coming soon...',

      // Email Page
      'Email Address': 'Email Address',
      'Registered Email': 'Registered Email',
      'No email available': 'No email available',
      'Note: Email change is not allowed for security reasons.':
          'Note: Email change is not allowed for security reasons.',

      // Saved Address Page
      'Governorate': 'Governorate',
      'City': 'City',
      'Area': 'Area',
      'Street': 'Street',
      'Building Number': 'Building Number',
      'Floor Number': 'Floor Number',
      'Apartment Number': 'Apartment Number',
      'Save Address': 'Save Address',
      'Success': 'Success',
      'Address updated successfully.': 'Address updated successfully.',

      // Delete Account
      'Warning!': 'Warning!',
      'Deleting your account will permanently erase all your data. This action cannot be undone.':
          'Deleting your account will permanently erase all your data. This action cannot be undone.',
      'Delete My Account': 'Delete My Account',
      'Re-authenticate': 'Re-authenticate',
      'Password': 'Password',
      'Confirm Delete': 'Confirm Delete',
      'Cancel': 'Cancel',
      'Deleted': 'Deleted',
      'Account deleted successfully': 'Account deleted successfully',
      'Failed to delete account': 'Failed to delete account',
      'service': 'service',

      // Edit Personal Info
      'Save': 'Save',
      'Personal information updated successfully.':
          'Personal information updated successfully.',

      // Pricing page
      'Pricing': 'Pricing',
      'Service Pricing': 'Service Pricing',

      // Issues page
      "Choose the issues you're facing": "Choose the issues you're facing",
      'Other': 'Other',
      'Write the issue': 'Write the issue',
      'Confirm Issues': 'Confirm Issues',
      'Alert': 'Alert',
      'Please select or write the issue.': 'Please select or write the issue.',
      'Sent': 'Sent',
      'Issues submitted successfully.': 'Issues submitted successfully.',
      'Error occurred while sending': 'Error occurred while sending',

      // Errors and location
      'Error': 'Error',
      'Location is disabled': 'Location is disabled',
      'Location permission denied': 'Location permission denied',
      'Location permission permanently denied':
          'Location permission permanently denied',
      'Failed to get location': 'Failed to get location',
      'Failed to send request': 'Failed to send request',
      'Unknown Name': 'Unknown Name',
      'Not Available': 'Not Available',

      // Payment / Pricing confirmation
      'Waiting for price': 'Waiting for price',
      'No request data available.': 'No request data available.',
      'Work started': 'Work started',
      'Working...': 'Working...',
      'Collect payment': 'Collect payment',
      'You must collect the amount from the customer:':
          'You must collect the amount from the customer:',
      'Collected': 'Collected',
      'Finish and collect': 'Finish and collect',
      'Price is set:': 'Price is set:',
      'Accept': 'Accept',
      'Reject': 'Reject',
      'Waiting for customer to confirm payment...':
          'Waiting for customer to confirm payment...',
      'Waiting for technician to confirm payment...':
          'Waiting for technician to confirm payment...',
      'Customer confirmed the payment.\nPlease confirm receipt.':
          'Customer confirmed the payment.\nPlease confirm receipt.',
      'Confirm cash receipt': 'Confirm cash receipt',
      'Please wait, you will be redirected after technician confirmation.':
          'Please wait, you will be redirected after technician confirmation.',
      'Thank you': 'Thank you',
      'Thank you for using Sal7ly': 'Thank you for using Sal7ly',
      'Please wait while the technician sets the price...':
          'Please wait while the technician sets the price...',
      'Confirm payment': 'Confirm payment',
      'You have rejected the price.\nYou must pay the service fee of 50 EGP':
          'You have rejected the price.\nYou must pay the service fee of 50 EGP',
      'Start Work': 'Start Work',
      'Work in Progress': 'Work in Progress',
      'Final Price': 'Final Price',
      'Finish Work': 'Finish Work',
      "Technician Tracking": "Technician Tracking",
      "Your Location": "Your Location",
      "Message on WhatsApp": "Message on WhatsApp",
      "Tracking the technician... This may take a few moments depending on the distance.":
          "Tracking the technician... This may take a few moments depending on the distance.",
      "Unknown": "Unknown",
      "Not available": "Not available",
      "Select Issues": "Select Issues",
      "Please select the issues you are facing:":
          "Please select the issues you are facing:",
      "Describe the issue": "Describe the issue",
      "Submit": "Submit",
      "Warning": "Warning",
      "Please select or enter an issue.": "Please select or enter an issue.",
      "Issues saved successfully.": "Issues saved successfully.",
      "Failed to save issues:": "Failed to save issues:",

      // ✅ Support Page
      'Customer Support': 'Customer Support',
      'How i can help you ?': 'Hello 👋\nDo you need help or have an issue?',
      'Start Chat': 'Start Chat',
      'Start New Chat': 'Start New Chat',
      'Type Your Message': 'Type your message...',
      'You will be answered within 5 minutes':
          'Please describe your issue. Our support team will respond shortly.',
      'ticket_closed_message': 'We hope we solved your issue ❤️',
      'error_title': 'Error',
      'error_start_chat': 'Failed to start chat.',
      'error_send_message': 'Failed to send message.',
      'Help': 'Help',
    },

    'ar_EG': {
      'Sal7ly': 'صلحلي',
      'Request Technician': 'طلب فني',
      'Account Settings': 'إعدادات الحساب',
      'Settings': 'الإعدادات',
      'Log Out': 'تسجيل الخروج',
      'Menu': 'القائمة',
      'Electrician': 'كهربائي',
      'Plumber': 'سباك',
      'Painter': 'نقاش',
      'Carpenter': 'نجار',
      'AC Technician': 'فني تكييفات',

      // Account settings
      'Personal Information': 'المعلومات الشخصية',
      'Saved Address': 'العنوان المحفوظ',
      'Email': 'البريد الإلكتروني',
      'Saved Cards': 'الكروت المحفوظة',
      'Notifications': 'الإشعارات',
      'Delete Account': 'حذف الحساب',
      'Change Language': 'تغيير اللغة',
      'English': 'الإنجليزية',
      'Arabic': 'العربية',

      // Request flow
      'Searching for': 'جارٍ البحث عن :service',
      'Looking for nearest': 'جارٍ البحث عن أقرب :service...',
      'seconds remaining': 'ثانية متبقية',
      'Cancel Request': 'إلغاء الطلب',
      'Technician Assigned': 'تم تعيين الفني',
      'Name': 'الاسم',
      'Phone': 'رقم الهاتف',
      'Rating': 'التقييم',
      'Arrival Time': 'وقت الوصول',
      'min': 'دقيقة',
      'minutes': 'دقيقة',
      'OK': 'موافق',
      'Request Timeout': 'انتهى الوقت',
      'No technician found.': 'لم يتم العثور على فني',
      'Incomplete user data': 'بيانات المستخدم غير مكتملة',

      // Notifications Page
      'Notifications settings coming soon...':
          'إعدادات الإشعارات قادمة قريبًا...',

      // Saved Cards Page
      'This feature is coming soon...': 'هذه الميزة قادمة قريبًا...',

      // Email Page
      'Email Address': 'عنوان البريد الإلكتروني',
      'Registered Email': 'البريد الإلكتروني المسجل',
      'No email available': 'لا يوجد بريد إلكتروني متاح',
      'Note: Email change is not allowed for security reasons.':
          'ملاحظة: لا يُسمح بتغيير البريد الإلكتروني لأسباب أمنية.',

      // Saved Address Page
      'Governorate': 'المحافظة',
      'City': 'المدينة',
      'Area': 'المنطقة',
      'Street': 'الشارع',
      'Building Number': 'رقم المبنى',
      'Floor Number': 'رقم الدور',
      'Apartment Number': 'رقم الشقة',
      'Save Address': 'حفظ العنوان',
      'Success': 'تم بنجاح',
      'Address updated successfully.': 'تم تحديث العنوان بنجاح.',

      // Delete Account
      'Warning!': 'تحذير!',
      'Deleting your account will permanently erase all your data. This action cannot be undone.':
          'حذف حسابك سيمحو جميع بياناتك بشكل دائم. لا يمكن التراجع عن هذا الإجراء.',
      'Delete My Account': 'احذف حسابي',
      'Re-authenticate': 'أعد تسجيل الدخول',
      'Password': 'كلمة المرور',
      'Confirm Delete': 'تأكيد الحذف',
      'Cancel': 'إلغاء',
      'Deleted': 'تم الحذف',
      'Account deleted successfully': 'تم حذف الحساب بنجاح',
      'Failed to delete account': 'فشل في حذف الحساب',
      'service': 'خدمة',

      // Edit Personal Info
      'Save': 'حفظ',
      'Personal information updated successfully.':
          'تم تحديث المعلومات الشخصية بنجاح.',

      // Pricing page
      'Pricing': 'التسعيرة',
      'Service Pricing': 'تسعيرة الخدمة',

      // Issues page
      "Choose the issues you're facing": "اختر الأعطال التي تواجهك",
      'Other': 'أخرى',
      'Write the issue': 'اكتب المشكلة',
      'Confirm Issues': 'تأكيد الأعطال',
      'Alert': 'تنبيه',
      'Please select or write the issue.': 'يرجى اختيار أو كتابة المشكلة.',
      'Sent': 'تم',
      'Issues submitted successfully.': 'تم إرسال الأعطال بنجاح.',
      'Error occurred while sending': 'حدث خطأ أثناء الإرسال',

      // Errors and location
      'Error': 'خطأ',
      'Location is disabled': 'خدمة الموقع غير مفعلة',
      'Location permission denied': 'تم رفض إذن الموقع',
      'Location permission permanently denied': 'تم رفض إذن الموقع نهائيًا',
      'Failed to get location': 'فشل في الحصول على الموقع',
      'Failed to send request': 'فشل في إرسال الطلب',
      'Unknown Name': 'اسم غير معروف',
      'Not Available': 'غير متوفر',

      // Payment / Pricing confirmation
      'Waiting for price': 'انتظار تحديد السعر',
      'No request data available.': 'لا يوجد بيانات للطلب.',
      'Work started': 'تم بدء العمل',
      'Working...': 'جاري العمل...',
      'Collect payment': 'تحصيل المبلغ',
      'You must collect the amount from the customer:':
          'يجب تحصيل المبلغ من العميل:',
      'Collected': 'تم التحصيل',
      'Finish and collect': 'إنهاء وتحصيل',
      'Price is set:': 'تم تحديد السعر:',
      'Accept': 'موافق',
      'Reject': 'رفض',
      'Waiting for customer to confirm payment...':
          'جارٍ انتظار العميل لتأكيد الدفع...',
      'Waiting for technician to confirm payment...':
          'جاري انتظار تأكيد الدفع من الفني...',
      'Customer confirmed the payment.\nPlease confirm receipt.':
          'تم تأكيد الدفع من العميل.\nيرجى تأكيد استلام المبلغ.',
      'Confirm cash receipt': 'تأكيد استلام المبلغ',
      'Please wait, you will be redirected after technician confirmation.':
          'برجاء الانتظار، سيتم تحويلك بعد تأكيد الفني.',
      'Thank you': 'شكراً لك',
      'Thank you for using Sal7ly': 'شكراً لاستخدامك صلحلي',
      'Please wait while the technician sets the price...':
          'يرجى الانتظار حتى يقوم الفني بتحديد السعر...',
      'Confirm payment': 'تأكيد الدفع',
      'You have rejected the price.\nYou must pay the service fee of 50 EGP':
          'لقد قمت برفض السعر.\nيجب دفع رسوم الخدمة 50 جنيه.',
      'Start Work': 'بدء العمل',
      'Work in Progress': 'جاري تنفيذ العمل...',
      'Final Price': 'السعر النهائي',
      'Finish Work': 'تم الانتهاء',
      "Technician Tracking": "تتبع الفني",
      "Your Location": "موقعك",
      "Message on WhatsApp": "مراسلة على واتساب",
      "Tracking the technician... This may take a few moments depending on the distance.":
          "جاري تتبع الفني... قد يستغرق وقتًا قليلًا حسب بُعده عنك.",
      "Unknown": "اسم غير معروف",
      "Not available": "غير متوفر",
      "Select Issues": "تحديد الأعطال",
      "Please select the issues you are facing:": "اختر الأعطال التي تواجهك:",
      "Describe the issue": "وصف العطل",
      "Submit": "إرسال",
      "Warning": "تحذير",
      "Please select or enter an issue.": "يرجى اختيار أو كتابة العطل.",
      "Issues saved successfully.": "تم حفظ الأعطال بنجاح.",
      "Failed to save issues:": "حدث خطأ أثناء الحفظ:",

      // ✅ Support Page
      'Customer Support': 'الدعم الفني',
      'How i can help you ?': 'مرحباً 👋\nهل تحتاج إلى مساعدة أو لديك مشكلة؟',
      'Start Chat': 'بدء المحادثة',
      'Start New Chat': 'ابدأ محادثة جديدة',
      'Type Your Message': 'اكتب رسالتك...',
      'You will be answered within 5 minutes':
          'يرجى وصف مشكلتك، وسنقوم بالرد خلال 5 دقائق.',
      'ticket_closed_message': 'نتمنى أن نكون قد حللنا مشكلتك ❤️',
      'error_title': 'خطأ',
      'error_start_chat': 'فشل في بدء المحادثة.',
      'error_send_message': 'فشل في إرسال الرسالة.',
      'Help': 'المساعدة',
    },
  };
}
