Feature Selection 
=================

Based on the experiments published in [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc\_XYZ and tGyro\_XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc\_XYZ and tGravityAcc\_XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk\_XYZ and tBodyGyroJerk\_XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc\_XYZ, fBodyAccJerk\_XYZ, fBodyGyro\_XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  '\_XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

  * tBodyAcc_XYZ  
  * tGravityAcc_XYZ  
  * tBodyAccJerk_XYZ  
  * tBodyGyro_XYZ  
  * tBodyGyroJerk\_XYZ  
  * tBodyAccMag  
  * tGravityAccMag  
  * tBodyAccJerkMag  
  * tBodyGyroMag  
  * tBodyGyroJerkMag  
  * fBodyAcc\_XYZ  
  * fBodyAccJerk\_XYZ  
  * fBodyGyro\_XYZ  
  * fBodyAccMag  
  * fBodyAccJerkMag  
  * fBodyGyroMag  
  * fBodyGyroJerkMag  

The set of variables that were estimated from these signals are: 

  * mean: Mean value  
  * std: Standard deviation

The complete list of feature is:

  1. tBodyAcc\_mean\_X  
  2. tBodyAcc\_mean\_Y  
  3. tBodyAcc\_mean\_Z  
  4. tBodyAcc\_std\_X  
  5. tBodyAcc\_std\_Y  
  6. tBodyAcc\_std\_Z  
  7. tGravityAcc\_mean\_X  
  8. tGravityAcc\_mean\_Y  
  9. tGravityAcc\_mean\_Z  
  10. tGravityAcc\_std\_X  
  11. tGravityAcc\_std\_Y  
  12. tGravityAcc\_std\_Z  
  13. tBodyAccJerk\_mean\_X  
  14. tBodyAccJerk\_mean\_Y  
  15. tBodyAccJerk\_mean\_Z  
  16. tBodyAccJerk\_std\_X  
  17. tBodyAccJerk\_std\_Y  
  18. tBodyAccJerk\_std\_Z  
  19. tBodyGyro\_mean\_X  
  20. tBodyGyro\_mean\_Y  
  21. tBodyGyro\_mean\_Z  
  22. tBodyGyro\_std\_X  
  23. tBodyGyro\_std\_Y  
  24. tBodyGyro\_std\_Z  
  25. tBodyGyroJerk\_mean\_X  
  26. tBodyGyroJerk\_mean\_Y  
  27. tBodyGyroJerk\_mean\_Z  
  28. tBodyGyroJerk\_std\_X  
  29. tBodyGyroJerk\_std\_Y  
  30. tBodyGyroJerk\_std\_Z  
  31. tBodyAccMag\_mean  
  32. tBodyAccMag\_std  
  33. tGravityAccMag\_mean  
  34. tGravityAccMag\_std  
  35. tBodyAccJerkMag\_mean  
  36. tBodyAccJerkMag\_std  
  37. tBodyGyroMag\_mean  
  38. tBodyGyroMag\_std  
  39. tBodyGyroJerkMag\_mean  
  40. tBodyGyroJerkMag\_std  
  41. fBodyAcc\_mean\_X  
  42. fBodyAcc\_mean\_Y  
  43. fBodyAcc\_mean\_Z  
  44. fBodyAcc\_std\_X  
  45. fBodyAcc\_std\_Y  
  46. fBodyAcc\_std\_Z  
  47. fBodyAcc\_meanFreq\_X  
  48. fBodyAcc\_meanFreq\_Y  
  49. fBodyAcc\_meanFreq\_Z  
  50. fBodyAccJerk\_mean\_X  
  51. fBodyAccJerk\_mean\_Y  
  52. fBodyAccJerk\_mean\_Z  
  53. fBodyAccJerk\_std\_X  
  54. fBodyAccJerk\_std\_Y  
  55. fBodyAccJerk\_std\_Z  
  56. fBodyAccJerk\_meanFreq\_X  
  57. fBodyAccJerk\_meanFreq\_Y  
  58. fBodyAccJerk\_meanFreq\_Z  
  59. fBodyGyro\_mean\_X  
  60. fBodyGyro\_mean\_Y  
  61. fBodyGyro\_mean\_Z  
  62. fBodyGyro\_std\_X  
  63. fBodyGyro\_std\_Y  
  64. fBodyGyro\_std\_Z  
  65. fBodyGyro\_meanFreq\_X  
  66. fBodyGyro\_meanFreq\_Y  
  67. fBodyGyro\_meanFreq\_Z  
  68. fBodyAccMag\_mean  
  69. fBodyAccMag\_std  
  70. fBodyAccMag\_meanFreq  
  71. fBodyBodyAccJerkMag\_mean  
  72. fBodyBodyAccJerkMag\_std  
  73. fBodyBodyAccJerkMag\_meanFreq  
  74. fBodyBodyGyroMag\_mean  
  75. fBodyBodyGyroMag\_std  
  76. fBodyBodyGyroMag\_meanFreq  
  77. fBodyBodyGyroJerkMag\_mean  
  78. fBodyBodyGyroJerkMag\_std  
  79. fBodyBodyGyroJerkMag\_meanFreq  
