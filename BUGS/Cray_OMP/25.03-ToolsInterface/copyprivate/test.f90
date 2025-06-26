program main
        integer :: val
        val = 0
!$OMP PARALLEL NUM_THREADS(4) PRIVATE(val)
!$OMP SINGLE
        val = 1
!$OMP END SINGLE COPYPRIVATE(val)
!$OMP END PARALLEL
end program main
