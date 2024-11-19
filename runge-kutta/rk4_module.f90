module rk4_module
    implicit none
    interface
        function f(x, y)
            real(8) :: f
            real(8), intent(in) :: x, y
        end function f
    end interface
    procedure(f), pointer :: func_ptr => null()
contains

    ! Runge-Kutta 4차 방법 구현
    subroutine rk4_step(x, y, h, dydx)
        real(8) :: x, y, h
        real(8) :: k1, k2, k3, k4
        real(8) :: dydx

        if (associated(func_ptr)) then
            k1 = h * func_ptr(x, y)
            k2 = h * func_ptr(x + 0.5*h, y + 0.5*k1)
            k3 = h * func_ptr(x + 0.5*h, y + 0.5*k2)
            k4 = h * func_ptr(x + h, y + k3)

            dydx = (k1 + 2.0*k2 + 2.0*k3 + k4) / 6.0
        else
            print *, "Error: Function pointer is not assigned."
            stop
        end if
    end subroutine rk4_step

end module rk4_module