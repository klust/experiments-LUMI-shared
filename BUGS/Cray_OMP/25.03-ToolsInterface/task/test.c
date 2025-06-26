int main( void )
{
    #pragma omp parallel num_threads( 2 )
    #pragma omp single
    {
	for( int i = 0; i < 3; ++i )
	{
	    #pragma omp task
		{}
	}
    }
}
