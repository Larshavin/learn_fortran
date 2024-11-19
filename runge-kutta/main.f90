program main
    use rk4_module
    implicit none
    real(8) :: x, y, h, dydx
    integer :: i, n, choice

    ! 함수 정의
    real(8) :: f1, f2
    external :: f1, f2

    ! 초기 조건 설정
    x = 0.0
    y = 1.0
    h = 0.1
    n = 20

    ! 사용자에게 함수 선택 입력 받기
    print *, "Choose the function:"
    print *, "1: f(x, y) = x * y"
    print *, "2: f(x, y) = x + y"
    read *, choice

    ! 함수 포인터 할당
    select case (choice)
        case (1)
            func_ptr => f1
        case (2)
            func_ptr => f2
        case default
            print *, "Invalid choice. Exiting."
            stop
    end select

    print *, " x", " y"

    ! Runge-Kutta 4차 방법으로 y 계산
    do i = 1, n
        call rk4_step(x, y, h, dydx)
        y = y + dydx
        x = x + h
        print *, x, y
    end do
end program main

! 함수 f1: f(x, y) = x * y
real(8) function f1(x, y)
    real(8), intent(in) :: x, y
    f1 = x * y
end function f1

! 함수 f2: f(x, y) = x + y
real(8) function f2(x, y)
    real(8), intent(in) :: x, y
    f2 = x + y
end function f2