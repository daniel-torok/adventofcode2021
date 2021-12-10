module type_Stack

  use, intrinsic :: iso_fortran_env, only: &
    stdout => OUTPUT_UNIT

  use type_Node, only: &
    Node

  ! Explicit typing only
  implicit none

  ! Everything is private unless stated otherwise
  private
  public :: Stack

  ! Declare the derived data type
  type, public :: Stack
    !----------------------------------------------------------------------
    ! Class variables
    !----------------------------------------------------------------------
    integer,              public :: size_of_stack = 0
    type (Node), pointer, public :: top => null()
    !----------------------------------------------------------------------
contains
    !----------------------------------------------------------------------
    ! Class methods
    !----------------------------------------------------------------------
    procedure, public :: push !! Insert element
    procedure, public :: pop !! Remove top element
    procedure, public :: peek !! Returns top element without removing
    procedure, public :: is_empty !! Test whether stack is empty
    procedure, public :: length !! Returns the number of elements in the stack
    procedure, public :: clear !! Removes all elements
    final             :: finalize_stack !! Destructor
    !----------------------------------------------------------------------
  end type Stack


contains


  subroutine push(this, n)
    !----------------------------------------------------------------------
    ! Dictionary: calling arguments
    !----------------------------------------------------------------------
    class (Stack),         intent (in out) :: this
    character(len=1),      intent (in)     :: n
    !----------------------------------------------------------------------
    ! Dictionary: local variables
    !----------------------------------------------------------------------
    class (Node), pointer, save :: ptr => null()
    !----------------------------------------------------------------------

    ! Create memory leak
    allocate ( ptr, source=Node(data=n, next=null()) )

    ! Push
    if (this%is_empty() .eqv. .false.) then
      ptr%next=> this%top
    end if

    ! Assign pointer
    this%top => ptr

    ! Increment size of stack
    associate( s => this%size_of_stack )
      s = s + 1
    end associate

  end subroutine push



  subroutine pop(this)
    !----------------------------------------------------------------------
    ! Dictionary: calling arguments
    !----------------------------------------------------------------------
    class (Stack),   intent (in out) :: this
    !----------------------------------------------------------------------
    ! Dictionary: local variables
    !----------------------------------------------------------------------
    class (Node), allocatable :: temp
    !----------------------------------------------------------------------

    ! Address the case when the stack is empty
    if (this%is_empty() .eqv. .true.) then
      write( stdout, '(A)') 'The stack is empty'
      return
    end if

    ! Make a copy
    allocate ( temp, source=this%top)

    ! Remove top element
    this%top => this%top%next

    ! Decrement size of stack
    associate( s => this%size_of_stack )
      s = s - 1
    end associate

    ! Release memory
    deallocate ( temp )

  end subroutine pop



  subroutine clear(this)
    !----------------------------------------------------------------------
    ! Dictionary: calling arguments
    !----------------------------------------------------------------------
    class (Stack),   intent (in out) :: this

    do while (this%is_empty() .neqv. .true.)
      call this%pop()
    end do
  end subroutine clear



  function peek(this) result (return_value)
    !----------------------------------------------------------------------
    ! Dictionary: calling arguments
    !----------------------------------------------------------------------
    class (Stack),    intent (in out) :: this
    character(len=1)                  :: return_value
    !----------------------------------------------------------------------

    ! Address the case when the stack is empty
    if (this%is_empty() .eqv. .true.) then
      write( stdout, '(A)') 'The stack is empty'
      return
    end if

    return_value = this%top%data

  end function peek



  function is_empty(this) result (return_value)
    !----------------------------------------------------------------------
    ! Dictionary: calling arguments
    !----------------------------------------------------------------------
    class (Stack), intent (in out) :: this
    logical                        :: return_value
    !----------------------------------------------------------------------

    return_value = ( .not.associated(this%top) )

  end function is_empty



  function length(this) result (return_value)
    !----------------------------------------------------------------------
    ! Dictionary: calling arguments
    !----------------------------------------------------------------------
    class (Stack), intent (in out) :: this
    integer                        :: return_value
    !----------------------------------------------------------------------

    return_value = this%size_of_stack

  end function length



  recursive subroutine finalize_stack(this)
    !----------------------------------------------------------------------
    ! Dictionary: calling arguments
    !----------------------------------------------------------------------
    type (Stack), intent (in out) :: this
    !----------------------------------------------------------------------

    if (this%is_empty() .eqv. .false.) deallocate (this%top)

  end subroutine finalize_stack


end module type_Stack
