! WRITTEN BY VINEETH RAVI
! FOLLOWING IS A UMAT CODE FOR LINEAR ELASTIC MATERIAL
! VARIABLES FROM THE LETTER I TO N ARE CONSIDEREDED TO BE INTEGERS
! AND VARIABLES STARTING WITH OTHER LETTERS ARE DOUBLE PRECISION
! SO PLEASE BE CAREFUL IN NAMING THE VARIABLES
! EXAMPLES OF FEW DEFAULT INTEGERS : NTENS, NDI, NSHR
! EXAMPLES OF FEW DEFAULT REAL NUMBERS : DDSDDE, STRESS, STRAN
      
      
      SUBROUTINE UMAT(STRESS,STATEV,DDSDDE,SSE,SPD,SCD,
     1 RPL,DDSDDT,DRPLDE,DRPLDT,
     2 STRAN,DSTRAN,TIME,DTIME,TEMP,DTEMP,PREDEF,DPRED,CMNAME,
     3 NDI,NSHR,NTENS,NSTATV,PROPS,NPROPS,COORDS,DROT,PNEWDT,
     4 CELENT,DFGRD0,DFGRD1,NOEL,NPT,LAYER,KSPT,JSTEP,KINC)

      INCLUDE 'ABA_PARAM.INC'

      CHARACTER*80 CMNAME
      DIMENSION STRESS(NTENS),STATEV(NSTATV),
     1 DDSDDE(NTENS,NTENS),DDSDDT(NTENS),DRPLDE(NTENS),
     2 STRAN(NTENS),DSTRAN(NTENS),TIME(2),PREDEF(1),DPRED(1),
     3 PROPS(NPROPS),COORDS(3),DROT(3,3),DFGRD0(3,3),DFGRD1(3,3),
     4 JSTEP(4)
      
      PARAMETER (ZERO = 0.0D0, ONE = 1.0D0, TWO = 2.0D0)
      E = PROPS(1)  ! YOUNGS MODULUS
      PR = PROPS(2) ! POISSONS RATIO
      G = E/(TWO*(ONE + PR))	 ! SHEAR MODULUS
      
      DELTA = E/((ONE + PR)*(ONE - TWO*PR)) 	  
      
      DO I=1,NTENS  ! INITIALIZATION OF JACOBIAN MATRIX
          DO J=1,NTENS
              DDSDDE(I,J) = ZERO
          ENDDO
      ENDDO
	   
      DDSDDE(1,1) = DELTA*(ONE - PR)
      DDSDDE(1,2) = PR*DELTA
      DDSDDE(1,3) = PR*DELTA
      DDSDDE(2,1) = PR*DELTA
      DDSDDE(2,2) = DELTA*(ONE - PR)
      DDSDDE(2,3) = PR*DELTA
      DDSDDE(3,1) = PR*DELTA
      DDSDDE(3,2) = PR*DELTA
      DDSDDE(3,3) = DELTA*(ONE - PR)
      DDSDDE(4,4) = G
      DDSDDE(5,5) = G
      DDSDDE(6,6) = G
      
      DO I=1, NTENS
          DO J=1, NTENS
              STRESS(I) = STRESS(I) + DDSDDE(I, J)*DSTRAN(J) ! UPDATING STRESS TENSOR   
              END DO
      END DO
      
      RETURN
      END