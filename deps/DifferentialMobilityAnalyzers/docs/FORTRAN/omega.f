!+
!     Knutson and Whitby (1975) DMA Transfer Function
!     
!     author: Markus Petters, May 2018
!             North Carolina State University
!             mdpetter@ncsu.edu
!-    
      REAL FUNCTION OMEGA(Z, ZS, BETA)
      REAL Z, ZS, BETA
      REAL TERM1, TERM2, TERM3
      IF (ZS > (1.0-BETA)*Z .AND. ZS < (1.0+BETA*Z)) THEN
          TERM1 = ABS(ZS/Z - (1.0 + BETA))
          TERM2 = ABS(ZS/Z - (1.0 - BETA))
          TERM3 = -2.0 * ABS(ZS/Z - 1.0)
          OMEGA = 1.0 / (2.0 * BETA) * (TERM1 + TERM2 + TERM3)
      ELSE 
          OMEGA = 0 
      END IF
      RETURN

      END
