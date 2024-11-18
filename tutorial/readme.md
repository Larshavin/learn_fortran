# Fortran tutorial

> Fortran은 **컴파일 언어**로, 작성된 소스 코드는 컴파일러를 통해 기계에서 실행 가능한 파일로 변환되어야 합니다.

``` shell
$ gfortran --version
GNU Fortran (Homebrew GCC 14.2.0_1) 14.2.0
Copyright (C) 2024 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```
--- 
## Hello World

``` fortran
program hello
  ! This is a comment line; it is ignored by the compiler
  print *, 'Hello, World!'
end program hello
```

``` sh
$ gfortran hello.f90 -o hello

$ ./hello
Hello, World!
```
--- 
## Variables

Fortran is a strongly typed language !

* integer – for data that represent whole numbers, positive or negative
* real – for floating-point data (not a whole number)
* complex – pair consisting of a real part and an imaginary part
* character – for text data
* logical – for data that represent boolean (true or false) values
--- 
## Declaring variables

``` fortran
<variable_type> :: <variable_name>, <variable_name>, ...
```

여기서 `<variable_type>`은 위에서 설명한 내장 변수 유형 중 하나이며, `<variable_name>`은 변수에 지정하고자 하는 이름입니다.

변수명은 반드시 문자로 시작해야 하며, 문자, 숫자, 그리고 밑줄(`_`)로 구성될 수 있습니다. 아래 예시에서는 각 내장 유형에 대해 변수를 선언하는 방법을 보여줍니다. 

``` fortran
program variables
  implicit none

  integer :: amount
  real :: pi, e ! two `real` variables declared
  complex :: frequency
  character :: initial
  logical :: isOkay

end program variables
```

* 포트란은 대소문자 구별이 없습니다.

프로그램의 시작 부분에 있는 추가 명령문 `implicit none`을 주목하세요. 이 명령문은 모든 변수가 명시적으로 선언되어야 함을 컴파일러에 알립니다. 이 명령문이 없으면, 변수는 시작되는 글자에 따라 암시적으로 유형이 지정됩니다.

모든 프로그램과 프로시저의 시작 부분에 반드시 `implicit none`을 사용하세요. 암시적 유형 지정은 현대 프로그래밍에서 좋은 습관이 아니며, 정보가 숨겨져 있어 프로그램 오류가 증가할 수 있습니다.

변수를 선언한 후에는 대입 연산자 `=`를 사용해 값을 할당하거나 다시 할당할 수 있습니다.

``` fortran
amount = 10
pi = 3.1415927
frequency = (1.0, -0.5)
initial = 'A'
isOkay = .false.
```

변수 선언과 값 할당을 동시에 진행할 수 있습니다. 이는 변수가 프로시저 호출 간에도 값을 유지함을 의미합니다. 하지만, 포트란에서는 좋은 프로그래밍 습관이 아니라고 합니다.

### Standard input / output

Hello World 예제에서 우리는 텍스트를 명령 창에 출력했습니다. 이는 일반적으로 표준 출력(`stdout`)에 쓰는 것으로 불립니다.

앞서 설명한 `print` 명령문을 사용하여 변수 값을 표준 출력(`stdout`)에 출력할 수 있습니다:

``` fortran
print *, 'The value of amount (integer) is: ', amount
print *, 'The value of pi (real) is: ', pi
print *, 'The value of frequency (complex) is: ', frequency
print *, 'The value of initial (character) is: ', initial
print *, 'The value of isOkay (logical) is: ', isOkay
```

비슷한 방식으로, `read` 명령문을 사용하여 명령 창에서 값을 읽을 수 있습니다:

```
program read_values
  implicit none
  real :: x, y

  print *, 'Please enter two numbers. '
  read(*,*) x, y

  print *, 'The sum and product of the numbers are ', x+y, x*y

end program read_values
```

### Expression 

| Operator | Description    |
| -------- | -------------- |
| **       | Exponent       |
| *        | Multiplication |
| /        | Division       |
| +        | Addition       |
| -        | Subtraction    |

``` fortran
program arithmetic
  implicit none

  real :: pi, radius, height, area, volume

  pi = 3.1415927

  print *, 'Enter cylinder base radius:'
  read(*,*) radius

  print *, 'Enter cylinder height:'
  read(*,*) height

  area = pi * radius**2
  volume = area * height

  print *, 'Cylinder radius is: ', radius
  print *, 'Cylinder height is: ', height
  print *, 'Cylinder base area is: ', area
  print *, 'Cylinder volume is: ', volume

end program arithmetic
```

### Floating-point precision

원하는 부동 소수점의 정밀도는 `kind` 매개변수를 사용해 명시적으로 선언할 수 있습니다. `iso_fortran_env` 내장 모듈은 일반적인 32비트 및 64비트 부동 소수점 유형을 위한 `kind` 매개변수를 제공합니다.

* Example: explicit real kind
``` fortran
program float
  use, intrinsic :: iso_fortran_env, only: sp=>real32, dp=>real64
  implicit none

  real(sp) :: float32
  real(dp) :: float64

  float32 = 1.0_sp  ! Explicit suffix for literal constants
  float64 = 1.0_dp
  print*, float32, float64
end program float
```

* Example: C-interoperable kind
``` fortran
program float
  use, intrinsic :: iso_c_binding, only: sp=>c_float, dp=>c_double
  implicit none

  real(sp) :: float32
  real(dp) :: float64

end program float
```

### Local scope variables with block construct

2008년 Fortran 표준에서는 `block` 개념이 도입되었습니다. 이를 통해 프로그램이나 프로시저 내에서 지역 범위 변수를 사용할 수 있습니다.

``` fortran 
module your_module
    implicit none
    integer :: n = 2
end module

program main
    implicit none
    real :: x

    block
        use your_module, only: n ! you can import modules within blocks
        real :: y ! local scope variable
        y = 2.0
        x = y ** n
        print *, y
    end block
    ! print *, y ! this is not allowed as y only exists during the block's scope
    print *, x  ! prints 4.00000000
end program
```
--- 
## Arrays and strings

대부분의 경우, 지금까지 사용했던 단일 스칼라 변수 대신 긴 숫자 목록을 저장하고 조작해야 합니다. 컴퓨터 프로그래밍에서는 이러한 목록을 **배열(array)** 이라고 합니다.

배열은 여러 값을 포함하는 다차원 변수로, 각각의 값은 하나 이상의 인덱스를 사용하여 접근할 수 있습니다.

Fortran에서 배열은 기본적으로 1부터 시작합니다. 즉, 어떤 차원이든 첫 번째 요소의 인덱스는 1입니다.

## Array declaration

모든 유형의 배열을 선언할 수 있습니다. 배열 변수를 선언하는 데에는 두 가지 일반적인 표기법이 있습니다: `dimension` 속성을 사용하는 방법과, 변수 이름 뒤에 괄호로 배열의 차원을 추가하는 방법입니다.

* Example: static array declaration
``` fortran 
program arrays
  implicit none

  ! 1D integer array
  integer, dimension(10) :: array1

  ! An equivalent array declaration
  integer :: array2(10)

  ! 2D real array
  real, dimension(10, 10) :: array3

  ! Custom lower and upper index bounds
  real :: array4(0:9)
  real :: array5(-5:5)

end program arrays
```

### Array slicing

Fortran 언어의 강력한 기능 중 하나는 배열 연산을 내장 지원한다는 점입니다. 배열 슬라이싱 표기법을 사용하여 배열 전체 또는 일부에 대해 연산을 수행할 수 있습니다

```
program array_slice
  implicit none

  integer :: i
  integer :: array1(10)  ! 1D integer array of 10 elements
  integer :: array2(10, 10)  ! 2D integer array of 100 elements

  array1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]  ! Array constructor
  array1 = [(i, i = 1, 10)]  ! Implied do loop constructor
  array1(:) = 0  ! Set all elements to zero
  array1(1:5) = 1  ! Set first five elements to one
  array1(6:) = 1  ! Set all elements after five to one

  print *, array1(1:10:2)  ! Print out elements at odd indices
  print *, array2(:,1)  ! Print out the first column in a 2D array
  print *, array1(10:1:-1)  ! Print an array in reverse

end program array_slice
```

Fortran 배열은 **열 우선(column-major)** 순서로 저장됩니다. 즉, 첫 번째 인덱스가 가장 빠르게 변합니다.

### Allocatable (dynamic) arrays

지금까지는 프로그램 코드에서 배열의 크기를 지정했습니다. 이러한 배열은 **정적 배열(static array)** 이라고 하며, 컴파일 시 크기가 고정됩니다.

그러나 종종 프로그램을 실행하기 전에는 배열의 크기를 알 수 없는 경우가 있습니다. 예를 들어, 크기를 알 수 없는 파일에서 데이터를 읽는 경우가 그렇습니다.

이 문제를 해결하기 위해 **할당 가능한 배열(allocatable array)** 을 사용해야 합니다. 할당 가능한 배열은 프로그램 실행 중에 배열의 크기를 결정한 후 동적으로 할당됩니다.

``` fortran
program allocatable
  implicit none

  integer, allocatable :: array1(:)
  integer, allocatable :: array2(:,:)

  allocate(array1(10))
  allocate(array2(10,10))

  ! ...

  deallocate(array1)
  deallocate(array2)

end program allocatable
```

할당 가능한 지역 배열은 스코프를 벗어날 때 자동으로 해제(deallocate)됩니다.

### Character strings

* Example: static character string
``` fortran
program string
  implicit none

  character(len=4) :: first_name
  character(len=5) :: last_name
  character(10) :: full_name

  first_name = 'John'
  last_name = 'Smith'

  ! String concatenation
  full_name = first_name//' '//last_name

  print *, full_name

end program string
```

* Example: allocatable character string
```fortran
program allocatable_string
  implicit none

  character(:), allocatable :: first_name
  character(:), allocatable :: last_name

  ! Explicit allocation statement
  allocate(character(4) :: first_name)
  first_name = 'John'

  ! Allocation on assignment
  last_name = 'Smith'

  print *, first_name//' '//last_name

end program allocatable_string
```

### Array of strings

Fortran에서 문자열 배열은 **문자(character)** 변수의 배열로 표현할 수 있습니다. 문자 배열의 모든 요소는 동일한 길이를 가집니다. 그러나 다양한 길이의 문자열을 배열 생성자에 입력할 수 있으며, 아래 예시에서처럼 사용할 수 있습니다. 문자열이 선언된 문자 배열의 길이보다 길면 잘리고, 짧으면 오른쪽에 공백이 추가됩니다. 마지막으로, 표준 출력에 값을 출력할 때는 내장 함수 `trim`을 사용하여 불필요한 공백을 제거합니다.

``` fortran
program string_array
  implicit none
  character(len=10), dimension(2) :: keys, vals

  keys = [character(len=10) :: "user", "dbname"]
  vals = [character(len=10) :: "ben", "motivation"]

  call show(keys, vals)

  contains

  subroutine show(akeys, avals)
    character(len=*), intent(in) :: akeys(:), avals(:)
    integer                      :: i

    do i = 1, size(akeys)
      print *, trim(akeys(i)), ": ", trim(avals(i))
    end do

  end subroutine show

end program string_array
```

## Operators and flow control

컴퓨터 알고리즘의 강력한 장점 중 하나는 단순한 수학 공식과 비교했을 때 **프로그램 분기(branching)** 기능을 통해 논리 조건에 따라 다음에 실행할 명령을 결정할 수 있다는 점입니다.

프로그램 흐름을 제어하는 주요 방식은 두 가지입니다:

1. **조건문 (if)**: 참(`true`) 또는 거짓(`false`)의 불리언 값에 따라 프로그램 경로를 선택합니다.
2. **반복문 (loop)**: 코드의 특정 부분을 여러 번 반복 실행합니다.
--- 
## Logical operators

To form a logical expression, the following set of relational operators are available:

| Operator | Alternative | description                                                     |
| -------- | ----------- | --------------------------------------------------------------- |
| ==       | .eq.        | Tests for equality of two operands                              |
| /=       | .ne.        | Test for inequality of two operands                             |
| >        | .gt.        | Tests if left operand is strictly greater than right operand    |
| <        | .lt.        | Tests if left operand is strictly less than right operand       |
| >=       | .ge.        | Tests if left operand is greater than or equal to right operand |
| <=>      | .le.        | Tests if left operand is less than or equal to right operand    |

as well as the following logical operators:

| Operator | Description                                                          |
| -------- | -------------------------------------------------------------------- |
| .and.    | TRUE if both left and right operands are TRUE                        |
| .or.     | TRUE if either left or right or both operands are TRUE               |
| .not.    | TRUE if right operand is FALSE                                       |
| .eqv.    | TRUE if left operand has same logical value as right operand         |
| .neqv.   | TRUE if left operand has the opposite logical value as right operand |

### Conditional construct (if)

* Example: single branch if
``` fortran
if (angle < 90.0) then
  print *, 'Angle is acute'
end if
```

* Example: two-branch if-else
``` fortran
if (angle < 90.0) then
  print *, 'Angle is acute'
else
  print *, 'Angle is obtuse'
end if
```

* Example: multi-branch if-else if-else
``` fortran
if (angle < 90.0) then
  print *, 'Angle is acute'
else if (angle < 180.0) then
  print *, 'Angle is obtuse'
else
  print *, 'Angle is reflex'
end if
```

### Conditional loop (do while)

`do` 반복문에 조건을 추가하려면 `while` 키워드를 사용할 수 있습니다. `while()`에 지정된 조건이 `.true.`로 평가되는 동안 반복문이 실행됩니다.

* Example: do while() loop
``` fortran
integer :: i

i = 1
do while (i < 11)
  print *, i
  i = i + 1
end do
! Here i = 11
```

### Loop control statements (exit and cycle)

대부분의 경우, 반복문은 특정 조건이 충족되면 중단되어야 합니다. Fortran은 이러한 상황을 처리하기 위해 두 가지 실행 가능한 명령문을 제공합니다.

`exit`는 반복문을 조기 종료할 때 사용됩니다. 일반적으로 `if` 조건문 내부에 포함됩니다.

* Example: loop with exit
``` fortran
integer :: i

do i = 1, 100
  if (i > 10) then
    exit  ! Stop printing numbers
  end if
  print *, i
end do
! Here i = 11
```

반면에, `cycle`은 반복문의 남은 부분을 건너뛰고 다음 반복으로 넘어갑니다.

* Example: loop with cycle
``` fortran
integer :: i

do i = 1, 10
  if (mod(i, 2) == 0) then
      cycle  ! Don't print even numbers
  end if
  print *, i
end do
```

### Nested loop control: tags

모든 프로그래밍 언어에서 반복적으로 등장하는 사례 중 하나는 **중첩 반복문(nested loops)** 의 사용입니다. 중첩 반복문이란, 하나의 반복문 내부에 또 다른 반복문이 존재하는 경우를 말합니다. Fortran에서는 각 반복문에 태그(이름)를 붙일 수 있습니다. 반복문에 태그를 붙이면 다음과 같은 두 가지 장점이 있습니다:

1. 태그의 이름이 의미가 있는 경우, 코드의 가독성이 향상될 수 있습니다.
2. `exit` 및 `cycle` 명령문을 태그와 함께 사용할 수 있어, 반복문에 대해 매우 세밀한 제어가 가능합니다.

* Example: tagged nested loops
``` fortran
integer :: i, j

outer_loop: do i = 1, 10
  inner_loop: do j = 1, 10
    if ((j + i) > 10) then  ! Print only pairs of i and j that add up to 10
      cycle outer_loop  ! Go to the next iteration of the outer loop
    end if
    print *, 'I=', i, ' J=', j, ' Sum=', j + i
  end do inner_loop
end do outer_loop
```

### Parallelizable loop (do concurrent)

`do concurrent` 반복문은 루프 내부에 상호 의존성이 없음을 명시적으로 나타내는 데 사용됩니다. 이는 컴파일러에 병렬화 또는 SIMD(단일 명령, 다중 데이터)를 사용해 반복문의 실행 속도를 높일 수 있음을 알리며, 프로그래머의 의도를 더 명확하게 전달합니다. 즉, 각 반복 실행은 다른 반복 실행의 이전 결과에 의존하지 않는다는 의미입니다. 또한, 반복문 내부에서 발생할 수 있는 상태 변경은 각 `do concurrent` 반복문 내부에서만 이루어져야 합니다. 이러한 요구 사항은 반복문 본문에 포함될 수 있는 내용에 제한을 둡니다.

> 단순히 `do` 반복문을 `do concurrent`로 바꾼다고 해서 병렬 실행이 보장되는 것은 아닙니다. 위 설명에서는 올바른 `do concurrent` 반복문을 작성하기 위해 충족해야 할 모든 요구 사항을 다루지 않았습니다. 컴파일러는 최적화 여부를 자유롭게 결정할 수 있으며, 간단한 계산이 포함된 반복 횟수가 적은 경우(아래 예시처럼) 최적화하지 않을 수도 있습니다. 일반적으로, `do concurrent` 반복문의 병렬화를 활성화하려면 컴파일러 플래그를 사용해야 합니다.

* Example: do concurrent() loop
``` fortran
real, parameter :: pi = 3.14159265
integer, parameter :: n = 10
real :: result_sin(n)
integer :: i

do concurrent (i = 1:n)  ! Careful, the syntax is slightly different
  result_sin(i) = sin(i * pi/4.)
end do

print *, result_sin
```
--- 
## Organising code structure

대부분의 프로그래밍 언어는 자주 사용되는 코드를 절차(procedure)로 묶어 다른 코드 섹션에서 호출하여 재사용할 수 있도록 합니다.

Fortran에는 두 가지 형태의 절차가 있습니다:

1. **서브루틴(Subroutine)**: `call` 명령문으로 호출됩니다.
2. **함수(Function)**: 표현식 내에서 호출되거나 값을 반환하여 할당에 사용됩니다.

서브루틴과 함수 모두 인수 연결(argument association)을 통해 상위 스코프의 변수에 접근할 수 있습니다. `value` 속성을 지정하지 않는 한, 이는 **참조에 의한 호출(call by reference)** 과 유사합니다.

## Subroutines

서브루틴의 입력 인수는 **더미 인수(dummy arguments)** 라고 하며, 서브루틴 이름 뒤의 괄호 안에 지정됩니다. 더미 인수의 유형과 속성은 지역 변수처럼 서브루틴 본문 내에서 선언됩니다.

``` fortran
! Print matrix A to screen
subroutine print_matrix(n,m,A)
  implicit none
  integer, intent(in) :: n
  integer, intent(in) :: m
  real, intent(in) :: A(n, m)

  integer :: i

  do i = 1, n
    print *, A(i, 1:m)
  end do

end subroutine print_matrix
```

더미 인수를 선언할 때 추가로 **intent 속성**을 지정할 수 있습니다. 이 선택적 속성은 프로시저 내에서 인수가 **읽기 전용**(`intent(in)`), **쓰기 전용**(`intent(out)`), 또는 **읽기-쓰기**(`intent(inout)`)인지 컴파일러에 알려줍니다. 예시에서 서브루틴은 인수를 수정하지 않으므로, 모든 인수는 `intent(in)`으로 지정됩니다.

더미 인수에 대해 항상 `intent` 속성을 지정하는 것이 좋은 습관입니다. 이를 통해 컴파일러는 의도하지 않은 오류를 검출할 수 있으며, 코드 자체에 설명(documentation)을 제공합니다.

이 서브루틴은 `call` 명령문을 사용하여 프로그램에서 호출할 수 있습니다:

``` fortran
program call_sub
  implicit none

  real :: mat(10, 20)

  mat(:,:) = 0.0

  call print_matrix(10, 20, mat)

end program call_sub
```

### Functions

``` fortran
! L2 Norm of a vector
function vector_norm(n,vec) result(norm)
  implicit none
  integer, intent(in) :: n
  real, intent(in) :: vec(n)
  real :: norm

  norm = sqrt(sum(vec**2))

end function vector_norm
```

To execute this function:

``` fortran
program run_fcn
  implicit none

  real :: v(9)
  real :: vector_norm

  v(:) = 9

  print *, 'Vector norm = ', vector_norm(9,v)

end program run_fcn
```

> 함수는 인수를 수정하지 않는 것이 좋은 프로그래밍 습관입니다. 즉, 모든 함수 인수는 `intent(in)`으로 지정되어야 합니다. 이러한 함수는 **순수 함수(pure function)** 라고 불립니다. 프로시저가 인수를 수정해야 하는 경우에는 **서브루틴(subroutine)** 을 사용하세요.

### Modules

Fortran 모듈은 정의된 내용을 프로그램, 프로시저, 그리고 다른 모듈에서 `use` 명령문을 통해 접근할 수 있게 합니다. 모듈에는 데이터 객체, 유형 정의, 프로시저, 인터페이스 등이 포함될 수 있습니다.

모듈의 주요 기능은 다음과 같습니다:

1. **제어된 범위 확장**: 모듈은 엔티티 접근을 명시적으로 제어할 수 있게 합니다.
2. **명시적 인터페이스 자동 생성**: 모듈은 현대적인 프로시저에 필요한 명시적 인터페이스를 자동으로 생성합니다.

함수와 서브루틴은 항상 모듈 내에 포함시키는 것이 권장됩니다.

``` fortran 
module my_mod
  implicit none

  private  ! All entities are now module-private by default
  public public_var, print_matrix  ! Explicitly export public entities

  real, parameter :: public_var = 2
  integer :: private_var

contains

  ! Print matrix A to screen
  subroutine print_matrix(A)
    real, intent(in) :: A(:,:)  ! An assumed-shape dummy argument

    integer :: i

    do i = 1, size(A,1)
      print *, A(i,:)
    end do

  end subroutine print_matrix

end module my_mod
```
> 모듈 외부에서 작성된 `print_matrix` 서브루틴과 비교해보면, 이제 행렬의 크기를 명시적으로 전달할 필요가 없습니다. 대신, **가정된 형태(assumed-shape)** 인수를 활용할 수 있으며, 모듈이 필요한 명시적 인터페이스를 자동으로 생성해줍니다. 이로 인해 서브루틴 인터페이스가 훨씬 간단해집니다.

To use the module within a program:
``` fortran 
program use_mod
  use my_mod
  implicit none

  real :: mat(10, 10)

  mat(:,:) = public_var

  call print_matrix(mat)

end program use_mod
```

* Example: explicit import list
``` fortran 
use my_mod, only: public_var
```

* Example: aliased import
``` fortran 
use my_mod, only: printMat=>print_matrix
```

### Optional arguments

서브루틴과 함수를 모듈에 포함시키는 장점 중 하나는 **옵션 인수(optional arguments)** 를 사용할 수 있다는 점입니다. 인수가 `optional`로 선언된 경우, `present` 함수를 사용하여 호출 시 인수가 전달되었는지 확인할 수 있습니다. 전달되지 않은 옵션 인수는 프로시저 내에서 접근할 수 없습니다.

다음은 벡터의 Lp norm을 계산하기 위해 2 이외의 제곱 값을 사용할 수 있도록 일반화된 `vector_norm` 함수의 예시입니다.

``` fortran 
module norm_mod
  implicit none
  contains
  function vector_norm(vec,p) result(norm)
    real, intent(in) :: vec(:)
    integer, intent(in), optional :: p ! power
    real :: norm
    if (present(p)) then ! compute Lp norm
      norm = sum(abs(vec)**p) ** (1.0/p)
    else ! compute L2 norm
      norm = sqrt(sum(vec**2))
    end if
  end function vector_norm
end module norm_mod

program run_fcn
  use norm_mod
  implicit none

  real :: v(9)

  v(:) = 9

  print *, 'Vector norm = ', vector_norm(v), vector_norm(v,2)
  print *, 'L1 norm = ', vector_norm(v,1)

end program run_fcn
```
--- 
## Derived Types

앞서 **변수(Variables)** 에서 설명한 것처럼, Fortran에는 다섯 가지 내장 데이터 유형이 있습니다. **파생 유형(derived type)** 은 내장 유형뿐만 아니라 다른 파생 유형도 캡슐화할 수 있는 특별한 데이터 유형입니다. 이는 C와 C++의 `struct`와 유사하다고 볼 수 있습니다.

### A quick take on derived types

``` fortran
type :: t_pair
  integer :: i
  real :: x
end type
```

The syntax to create a variable of type t_pair and access its members is: 
``` fortran
! Declare
type(t_pair) :: pair
! Initialize
pair%i = 1
pair%x = 0.5
```
> The percentage symbol % is used to access the members of a derived type.

위 코드에서 파생 유형의 인스턴스를 선언하고, 멤버를 명시적으로 초기화했습니다. 파생 유형의 멤버는 **파생 유형 생성자(derived type constructor)** 를 사용하여 초기화할 수도 있습니다.

다음은 파생 유형 생성자를 사용한 예시입니다:
``` fortran
pair = t_pair(1, 0.5)      ! Initialize with positional arguments
pair = t_pair(i=1, x=0.5)  ! Initialize with keyword arguments
pair = t_pair(x=0.5, i=1)  ! Keyword arguments can go in any order
```

기본 초기화를 사용한 예시:
``` fortran
type :: t_pair
  integer :: i = 1
  real :: x = 0.5
end type

type(t_pair) :: pair
pair = t_pair()       ! pair%i is 1, pair%x is 0.5
pair = t_pair(i=2)    ! pair%i is 2, pair%x is 0.5
pair = t_pair(x=2.7)  ! pair%i is 1, pair%x is 2.7
```

### Derived types in detail

The full syntax of a derived type with all optional properties is presented below:

``` fortran
type [,attribute-list] :: name [(parameterized-declaration-list)]
  [parameterized-definition-statements]
  [private statement or sequence statement]
  [member-variables]
contains
  [type-bound-procedures]
end type
```

### Options to declare a derived type

`attribute-list`는 다음과 같은 속성을 포함할 수 있습니다:

1. **접근 유형 (access-type)**: `public` 또는 `private`으로 설정하여 멤버의 접근 권한을 제어합니다.
2. **`bind(c)`**: C 프로그래밍 언어와의 상호 운용성을 제공합니다.
3. **`extends(parent)`**: 현재 파생 유형이 이전에 선언된 파생 유형(`parent`)으로부터 모든 멤버와 기능을 상속받습니다.
4. **`abstract`**: 객체 지향 기능으로, 고급 프로그래밍 튜토리얼에서 다루는 추상 유형을 정의합니다.

> `bind(c)` 속성 또는 `sequence` 문이 사용되는 경우, 파생 유형에 `extends` 속성을 사용할 수 없으며, 그 반대도 마찬가지입니다.

**`sequence`** 속성은 파생 유형의 멤버가 정의된 순서대로 접근되어야 함을 나타낼 때만 사용할 수 있습니다.

* Example with sequence:
``` fortran
type :: t_pair
  sequence
  integer :: i
  real :: x
end type
! Initialize
type(t_pair) :: pair
pair = t_pair(1, 0.5)
```

> `sequence` 문을 사용할 때는 아래에 정의된 데이터 유형이 **할당 가능(allocatable)**이거나 **포인터(pointer)** 유형이 아님을 전제합니다. 또한, 이 문은 해당 데이터 유형이 메모리에 특정 형태로 저장된다는 의미가 아닙니다. 즉, **`contiguous`** 속성과는 관련이 없습니다. `public`과 `private` 같은 접근 유형 속성을 사용할 경우, 아래에 선언된 모든 멤버 변수는 자동으로 해당 속성이 지정됩니다.

**`bind(c)`** 속성은 Fortran의 파생 유형과 C 언어의 `struct` 간의 호환성을 제공하기 위해 사용됩니다.

다음은 **`bind(c)`** 를 사용한 예시입니다:​⬤
``` fortran
module f_to_c
  use iso_c_bindings, only: c_int
  implicit none

  type, bind(c) :: f_type
    integer(c_int) :: i
  end type

end module f_to_c
```

matches the following C struct type:

``` c
struct c_struct {
  int i;
};
```

> Fortran에서 **`bind(c)`** 속성을 가진 파생 유형은 **`sequence`** 및 **`extends`** 속성을 가질 수 없습니다. 또한 Fortran의 포인터(pointer)나 할당 가능(allocatable) 유형을 포함할 수 없습니다.

**`parameterized-declaration-list`** 는 선택적인 기능입니다. 사용 시, `[parameterized-definition-statements]` 대신 파라미터를 나열해야 하며, 이 파라미터는 **길이(len)** 또는 **종류(kind)** 파라미터, 혹은 둘 다여야 합니다.

**`public`** 속성을 가진 **`parameterized-declaration-list`** 의 파생 유형 예시:

``` fortran
module m_matrix
 implicit none
 private

 type, public :: t_matrix(rows, cols, k)
   integer, len :: rows, cols
   integer, kind :: k = kind(0.0)
   real(kind=k), dimension(rows, cols) :: values
 end type

end module m_matrix

program test_matrix
 use m_matrix
 implicit none

 type(t_matrix(rows=5, cols=5)) :: m

end program test_matrix
```

> 이 예시에서 파라미터 `k`는 이미 기본값으로 `kind(0.0)` (단정밀도 부동 소수점)으로 할당되어 있습니다. 따라서, 메인 프로그램의 선언에서처럼 생략할 수 있습니다.

> 기본적으로, 파생 유형과 그 멤버들은 `public` 속성을 가집니다. 하지만 이 예시에서는 모듈의 시작 부분에 `private` 속성이 사용되었습니다. 따라서 모듈 내의 모든 내용은 명시적으로 `public`으로 선언되지 않는 한 기본적으로 `private`이 됩니다. 위 예시에서 `t_matrix` 유형이 `public` 속성을 가지지 않았다면, 프로그램 `test` 내에서 컴파일러가 오류를 발생시켰을 것입니다.

**`extends`** 속성은 F2003 표준에서 추가되었으며, 객체 지향 패러다임(OOP)의 중요한 기능인 상속을 도입합니다. 이를 통해 자식 유형이 확장 가능한 부모 유형에서 상속받아 코드 재사용이 가능합니다: `type, extends(parent) :: child`. 여기서 `child`는 `type :: parent`의 모든 멤버와 기능을 상속받습니다.

**`extends`** 속성을 사용한 예시:
``` fortran
module m_employee
  implicit none
  private
  public t_date, t_address, t_person, t_employee
  ! Note another way of using the public attribute:
  ! gathering all public data types in one place.

  type :: t_date
    integer :: year, month, day
  end type

  type :: t_address
    character(len=:), allocatable :: city, road_name
    integer :: house_number
  end type

  type, extends(t_address) :: t_person
    character(len=:), allocatable :: first_name, last_name, e_mail
  end type

  type, extends(t_person)  :: t_employee
    type(t_date) :: hired_date
    character(len=:), allocatable :: position
    real :: monthly_salary
  end type

end module m_employee

program test_employee
  use m_employee
  implicit none
  type(t_employee) :: employee

  ! Initialization

  ! t_employee has access to type(t_date) members not because of extends
  ! but because a type(t_date) was declared within t_employee.
  employee%hired_date%year  = 2020
  employee%hired_date%month = 1
  employee%hired_date%day   = 20

  ! t_employee has access to t_person, and inherits its members due to extends.
  employee%first_name = 'John'
  employee%last_name  = 'Doe'

  ! t_employee has access to t_address, because it inherits from t_person,
  ! which in return inherits from t_address.
  employee%city         = 'London'
  employee%road_name    = 'BigBen'
  employee%house_number = 1

  ! t_employee has access to its defined members.
  employee%position       = 'Intern'
  employee%monthly_salary = 0.0

end program test_employee
```

### Options to declare members of a derived type

`[member-variables]`는 모든 멤버 데이터 유형의 선언을 나타냅니다. 이러한 데이터 유형은 어떤 내장 데이터 유형이든, 또는 다른 파생 유형이 될 수 있습니다. 이는 이전 예시에서도 이미 보여주었습니다. 그러나 멤버 변수는 다음과 같은 확장된 문법을 가질 수 있습니다:

`type [,member-attributes] :: name[attr-dependent-spec][init]`

- **type**: 내장 유형 또는 다른 파생 유형
- **member-attributes** (선택 사항):
  - `public` 또는 `private` 접근 속성
  - 동적 배열을 지정하기 위해 `allocatable` (차원이 있을 수도 있고 없을 수도 있음)
  - `pointer`, `codimension`, `contiguous`, `volatile`, `asynchronous`

일반적인 사례의 예시:

``` fortran
type :: t_example
  ! 1st case: simple built-in type with access attribute and [init]
  integer, private :: i = 0
  ! private hides it from use outside of the t_example's scope.
  ! The default initialization [=0] is the [init] part.

  ! 2nd case: dynamic 1-D array
  real, allocatable, dimension(:) :: x
  ! the same as
  real, allocatable :: x(:)
  ! This parentheses' usage implies dimension(:) and is one of the possible [attr-dependent-spec].
end type
```

> 다음 속성들: `pointer`, `codimension`, `contiguous`, `volatile`, `asynchronous`는 고급 기능이며, Quickstart 튜토리얼에서는 다루지 않습니다. 그러나 이러한 기능이 존재한다는 것을 독자가 인식할 수 있도록 여기서 간략히 소개합니다. 이 기능들은 이후 출간될 고급 프로그래밍 미니북에서 자세히 다룰 예정입니다.

### Type-bound procedures

파생 유형에는 해당 유형에 바인딩된 함수나 서브루틴을 포함할 수 있습니다. 이를 **유형 바운드 절차(type-bound procedures)** 라고 부릅니다. 유형 바운드 절차는 모든 멤버 변수 선언 뒤에 오는 `contains` 문 다음에 정의됩니다.

현대 Fortran의 객체 지향(OOP) 기능을 깊이 다루지 않고는 유형 바운드 절차를 완전히 설명할 수 없습니다. 지금은 간단한 예시를 통해 기본적인 사용법을 살펴보겠습니다.

다음은 기본적인 유형 바운드 절차를 포함한 파생 유형의 예시입니다:

``` fortran
module m_shapes
  implicit none
  private
  public t_square

  type :: t_square
  real :: side
  contains
    procedure :: area  ! procedure declaration
  end type

contains

  ! Procedure definition
  real function area(self) result(res)
    class(t_square), intent(in) :: self
    res = self%side**2
  end function

end module m_shapes

program main
  use m_shapes
  implicit none

  ! Variables' declaration
  type(t_square) :: sq
  real :: x, side

  ! Variables' initialization
  side = 0.5
  sq%side = side

  x = sq%area()
  ! self does not appear here, it has been passed implicitly

  ! Do stuff with x...

end program main
```

**새로운 점:**

- **`self`** 는 파생 유형 `t_square`의 인스턴스를 나타내기 위해 선택한 임의의 이름입니다. 이를 통해 멤버에 접근할 수 있으며, 유형 바운드 절차를 호출할 때 자동으로 인수로 전달됩니다.
- 이제 `area` 함수의 인터페이스에서 **`type(t_square)`** 대신 **`class(t_square)`** 를 사용합니다. 이를 통해 `t_square`를 확장하는 모든 파생 유형에서 `area` 함수를 호출할 수 있습니다. **`class`** 키워드는 객체 지향(OOP) 기능인 **다형성(polymorphism)** 을 도입합니다.
- 위 예시에서 유형 바운드 절차 `area`는 함수로 정의되었으며, **표현식** 내에서만 호출할 수 있습니다. 예를 들어, `x = sq%area()` 또는 `print *, sq%area()`와 같이 사용합니다. 만약 이를 서브루틴으로 정의했다면, 별도의 `call` 문을 사용해 호출할 수 있습니다:

``` fortran
! Change within module
contains
  subroutine area(self, x)
    class(t_square), intent(in) :: self
    real, intent(out) :: x
    x = self%side**2
  end subroutine

! ...

! Change within main program
call sq%area(x)

! Do stuff with x...
```

유형 바운드 함수 예시와는 달리, 이제 두 개의 인수를 사용합니다:

1. `class(t_square), intent(in) :: self` – 파생 유형의 인스턴스 자체를 나타냅니다.
2. `real, intent(out) :: x` – 계산된 면적을 저장하고 호출자에게 반환하는 데 사용됩니다.​
   
--- 

## Gotchas

Fortran의 문법은 일반적으로 간단하고 일관성이 있지만, 다른 많은 언어와 마찬가지로 몇 가지 단점도 존재합니다. 이러한 단점은 때때로 **레거시 코드** 때문입니다. Fortran 표준의 발전은 여전히 적극적으로 사용되고 있는 방대한 양의 레거시 코드를 고려하여 **하위 호환성**을 강하게 강조합니다. 또 때로는 실제적인 결함, 즉 잘못된 선택이 있었으나, 이를 수정하려면 하위 호환성을 깨지 않고는 불가능한 경우도 있습니다. 그리고 단순히 Fortran이 C, C++, Python과는 다른 언어이기 때문일 수도 있습니다. Fortran은 고유한 논리를 가지고 있으며, 다른 언어에 익숙한 개발자에게는 때로는 놀라운 기능도 있습니다.

모든 코드 예시는 `gfortran 13`으로 컴파일됩니다.​

### Implicit typing

``` fortran
program foo
    integer :: nbofchildrenperwoman, nbofchildren, nbofwomen
    nbofwomen = 10
    nbofchildrenperwoman = 2
    nbofchildren = nbofwomen * nbofchildrenperwoman
    print*, "number of children:", nbofchildrem
end program
```

The program compiles and the execution gives:

``` shell
 number of children:           0
```

잠깐… Fortran이 두 개의 정수를 곱할 수 없다고요?? 물론 그렇지 않습니다… 여기서 문제는 출력 시 변수 이름에 오타가 있는 경우입니다: `nbofchildreM` 대신 `nbofchildreN`으로 작성했습니다. 그런데 왜 컴파일러가 이 오타를 잡아내지 못했을까요? 기본적으로 Fortran은 **암시적 유형 지정(implicit typing)**을 사용하기 때문입니다. 명시적으로 유형이 지정되지 않은 변수를 만나면, 컴파일러는 변수 이름의 첫 글자에 따라 유형을 추론합니다. 변수명이 `I`, `J`, `K`, `L`, `M`, `N`으로 시작하면 **정수(INTEGER)** 유형으로 간주되고, 그 외의 변수명은 **실수(REAL)** 유형으로 간주됩니다. 그래서 "GOD is REAL, unless declared as INTEGER"라는 고전적인 농담이 있는 것입니다.

암시적 유형 지정은 Fortran의 초창기부터 존재하던 기능으로, 명시적 유형 지정이 없던 시절에 도입되었습니다. 간단한 테스트 코드를 빠르게 작성할 때 여전히 편리할 수 있지만, 이 방식은 오류 발생 가능성이 높아 권장되지 않습니다. 강력하게 추천되는 좋은 습관은 모든 프로그램 단위(메인 프로그램, 모듈, 독립 루틴)의 시작 부분에 **`implicit none`**(Fortran 90에서 도입)을 작성하여 암시적 유형 지정을 비활성화하는 것입니다:

``` fortran
program foo
implicit none
    integer :: nbofchildrenperwoman, nbofchildren, nbofwomen
    nbofwomen = 10
    nbofchildrenperwoman = 2
    nbofchildren = nbofwomen * nbofchildrenperwoman
    print*, "number of children:", nbofchildrem
end program
```

And now the compilation fails, allowing to quickly correct the typo:

``` 
    7 |     print*, "number of children:", nbofchildrem
      |                                               1
Error: Symbol 'nbofchildrem' at (1) has no IMPLICIT type; did you mean 'nbofchildren'?
```

### Implied save

``` fortran
subroutine foo()
implicit none
    integer :: c=0

    c = c+1
    print*, c
end subroutine

program main
implicit none
    integer :: i

    do i = 1, 5
        call foo()
    end do
end program
```

C/C++에 익숙한 사람들은 이 프로그램이 1을 5번 출력할 것이라고 예상할 수 있습니다. 그 이유는 `integer :: c=0`이 선언과 할당이 결합된 것처럼 해석되기 때문입니다. 마치 다음과 같이 작성된 것으로 착각하는 것이죠:

```
integer :: c
c = 0
```

But it is not. This program actually outputs:

```
1
2
3
4
5
```

`integer :: c=0`는 사실 **컴파일 시점의 1회 초기화**입니다. 이로 인해 변수는 `foo()` 함수 호출 간에도 값을 유지하게 됩니다. 이는 다음과 동일합니다:

```fortran
integer, save :: c = 0 ! "save" can be omitted, but it's clearer with it
```

`save` 속성은 C 언어의 `static` 속성과 동일하며, 함수 내부에서 변수를 **지속성(persistent)** 있게 만듭니다. 변수가 초기화된 경우, `save` 속성은 자동으로 적용됩니다. 이는 Fortran 90에서 도입된 현대적인 문법으로, 기존의 (여전히 유효한) 문법과 비교됩니다:

```fortran
integer c
data c /0/
save c
```

오래된 Fortran 사용자들은 `save`가 명시되지 않더라도, 현대 문법이 기존 문법과 동일하다는 것을 알고 있습니다. 하지만 암시적인 `save` 속성은 C 언어의 논리에 익숙한 초보자들에게 혼란을 줄 수 있습니다. 그래서 일반적으로는 `save` 속성을 항상 명시적으로 지정하는 것이 권장됩니다.

참고: 파생 유형의 구성 요소 초기화 표현식은 완전히 다른 경우입니다.

```fortran
type bar
    integer :: c = 0
end type
```

여기서 `c` 구성 요소는 `type(bar)` 변수가 인스턴스화될 때마다 0으로 초기화됩니다 (런타임 초기화).

### Floating point literal constants

다음 코드 스니펫은 **배정밀도(double precision)** 상수 `x`를 정의합니다. 대부분의 시스템에서는 IEEE754 64비트 부동 소수점(유효 자릿수 15자리)으로 처리됩니다:

```fortran
program foo
implicit none
    integer, parameter :: dp = kind(0d0)
    real(kind=dp), parameter :: x = 9.3
    print*, precision(x), x
end program
```

출력 결과는 다음과 같습니다:
```
          15   9.3000001907348633
```

따라서 x는 예상대로 15자리의 유효 자릿수를 가지지만, 출력된 값은 8번째 자리부터 잘못되었습니다. 그 이유는 부동 소수점 리터럴 상수는 기본적으로 **단정밀도(single precision)** 로 처리되기 때문입니다. 일반적으로 이는 IEEE754 단정밀도 부동 소수점(약 7자리의 유효 자릿수)입니다. 이때, 실수 9.3은 정확한 부동 소수점 표현이 없어 먼저 단정밀도로 근사화되고, 이후 배정밀도로 형 변환되어 x에 할당됩니다. 하지만 이미 손실된 자릿수는 복구되지 않습니다.

해결 방법은 상수의 kind를 명시적으로 지정하는 것입니다:

```fortran
real(kind=dp), parameter :: x = 9.3_dp
```

이제 출력은 15번째 자리까지 정확합니다:

```
          15   9.3000000000000007
```

 
### Floating point literal constants (again)

이제 **1/3** (삼분의 일)인 부동 소수점 상수가 필요하다고 가정해 봅시다. 다음과 같이 작성할 수 있습니다:

```fortran
program foo
implicit none
    integer, parameter :: dp = kind(0d0)
    real(dp), parameter :: onethird = 1_dp / 3_dp
    print*, onethird
end program
```

그러면 출력 결과는 (!) 다음과 같습니다:
```
   0.0000000000000000     
```
이유는 1_dp와 3_dp는 정수 리터럴 상수이기 때문입니다. _dp 접미사는 부동 소수점의 kind를 나타내지만, 상수 자체는 여전히 정수입니다. 결과적으로 이 연산은 정수 나눗셈이 되어, 결과가 0이 됩니다. 여기서의 문제는 Fortran 표준이 REAL 및 INTEGER 유형에 대해 동일한 kind 값을 사용하는 것을 허용한다는 점입니다. 예를 들어 gfortran에서는 대부분의 플랫폼에서 dp 값이 배정밀도(double precision) kind이자 64비트 정수 kind로 사용됩니다. 따라서 1_dp는 유효한 정수 상수로 간주됩니다. 반면, NAG 컴파일러는 기본적으로 고유한 kind 값을 사용하므로, 위 예시에서는 1_dp가 컴파일 오류를 발생시킬 수 있습니다.

부동 소수점 상수를 표기하는 올바른 방법은 항상 소수점을 포함시키는 것입니다:

```fortran
real(dp), parameter :: onethird = 1.0_dp / 3.0_dp
```

그러면 출력 결과는 다음과 같이 정확해집니다:

```
  0.33333333333333331     
```

### Leading space in prints

```fortran
program foo
implicit none
    print*, "Hello world!"
end program
```
Ouput:
```
% gfortran hello.f90 && ./a.out
 Hello world! 
```

출력된 문자열의 맨 앞에 **추가된 공백**이 있다는 점을 주목하세요. 이 공백은 소스 코드 문자열에는 없습니다. 역사적으로, 초기 프린터에서는 첫 번째 문자가 캐리지 제어 코드(carriage control code)를 포함하고 있었으며, 이 문자는 실제로 출력되지 않았습니다. 공백 `" "`은 프린터에게 **CR+LF** (캐리지 리턴 + 줄 바꿈) 동작을 수행한 후에 내용을 출력하라는 지시를 했으며, Fortran의 `print*` 명령문이 자동으로 이 공백을 추가했습니다. 일부 컴파일러는 여전히 이 동작을 수행하지만, 현대의 출력 장치에서는 이 제어 문자를 해석하거나 사용하지 않으므로, 대신 공백이 출력됩니다.

이 선행 공백이 문제가 되는 경우(드물게 발생하지만), `*` (컴파일러가 출력 형식을 결정하도록 하는 표기) 대신 **명시적인 형식**을 지정할 수 있습니다:

``` fortran
    print "(A)", "Hello world!"
```
이 경우, 컴파일러는 더 이상 선행 공백을 추가하지 않습니다:
```
% gfortran hello.f90 && ./a.out
Hello world!
```
### Filename extension

위의 "Hello world" 프로그램을 소스 파일 `hello.f`에 넣었다고 가정해 봅시다. 대부분의 컴파일러는 여러 컴파일 오류를 발생시킬 것입니다:

```
% gfortran hello.f
hello.f:1:1:

 program foo
 1
Error: Non-numeric character in statement label at (1)
hello.f:1:1:

 implicit none
 1
Error: Non-numeric character in statement label at (1)
hello.f:2:1:

     print*, "Hello world!"
     1
Error: Non-numeric character in statement label at (1)

...[truncated]
```

`.f` 확장자는 널리 받아들여진 관례로, **고정 소스 형식(fixed source form)**의 레거시 코드에 "예약"되어 있습니다. 이 형식은 펀치 카드 시스템을 위해 설계되었습니다. 특히, 1-6열은 레이블, 연속 문자, 주석에 사용되었으며, 실제 명령문은 7-72열 내에 있어야 했습니다. **자유 소스 형식(free source form)** 은 고정 소스 형식의 이러한 제한을 모두 제거합니다. 하지만 고정 형식과 자유 형식이 공존하므로, 대부분의 컴파일러는 기본적으로 자유 형식 소스 파일에 `.f90` 확장자를 사용하도록 되어 있습니다. 이 설정은 일반적으로 컴파일러 옵션으로 변경할 수 있으며, 최신 버전의 **Fortran 패키지 관리자(fpm)** 는 확장자와 상관없이 기본적으로 모든 소스를 자유 형식으로 간주합니다.

**참고:** 흔히 오해하는 점은 `.f90` 소스 파일이 Fortran 90 표준 개정판에만 한정되고, Fortran 95/2003/2008/2018 개정판에서 도입된 기능을 포함할 수 없다는 것입니다. 이는 잘못된 정보이며 전혀 관련이 없습니다. `.f90`이 선택된 유일한 이유는 자유 형식이 Fortran 90 개정판에서 도입되었기 때문입니다. `.f`와 `.f90` 소스 파일 모두 모든 개정판의 기능을 포함할 수 있습니다.