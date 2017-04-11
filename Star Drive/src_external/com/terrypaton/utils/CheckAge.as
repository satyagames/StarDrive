package com.terrypaton.utils {
	public class CheckAge {
	
	// USAGE - commaNumber.processNumber(12000) - Returns "12,000"
	public static function checkAge($ageToCheck:int, $month:int, $day:int, $year:int):Boolean
        {
            var todayDate:Date = new Date();
            var currentMonth:int = (todayDate.getMonth() + 1);
            var currentDay:int = todayDate.getDate();
            var currentYear:int = todayDate.getFullYear();
           
            var userMonth:int = $month;
            var userDay:int = $day;
            var userYear:int = $year;
           if (userYear < 1900) {
			   return false
		   }
            var yearDiff:int = (currentYear - userYear);
           //trace(yearDiff)
            if (yearDiff == $ageToCheck)
            {
                // AGE IS EQUAL to VALID AGE ... need to check month and day
                var monthDiff:int = (currentMonth - userMonth);
               
                if (monthDiff == 0)
                {
                    // MONTH IS EQUAL ... need to check day
                    var dayDiff:int = currentDay - userDay;
                   
                    if (dayDiff>= 0)
                    {
                        // DAY IS EQUAL OR GREATER .. PASS
                        return true;
                    }
                    else
                    {
                        // DAY INVALID ... too young
                        return false;
                    }
                       
                }
                else if (monthDiff <0)
                {
                    // MONTH INVALID ... too young
                    return false;
                }
                else
                {
                    // AGE PASS
                    return true;
                }
            }
            else if (yearDiff <$ageToCheck)
            {
                // YEAR INVALID ... too young
                return false;
            }
            else
            {
                // OVER AGE in YEARS
                return true;
            }
        }
		
	}
	
	
}