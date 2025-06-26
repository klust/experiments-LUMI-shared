#include <omp.h>

int main( void )
{
    omp_set_num_threads( 4 );

    #pragma omp parallel
    #pragma omp single nowait
    {
        #pragma omp taskloop
        for( int i = 0; i < 10; ++i )
        {
							            
        }
    }
	    
    return 0;
}
