program main

  use, intrinsic :: iso_fortran_env, only: &
    stdout => OUTPUT_UNIT

  use type_Stack, only: &
    Stack

  ! Explicit typing only
  implicit none

  !--------------------------------------------------------------------------
  ! Dictionary
  !--------------------------------------------------------------------------
  type (Stack)        :: s
  integer             :: ios             !! IO status of file operation
  integer             :: i               !! Counter
  integer             :: incomplete = 0  !! Counter
  integer             :: idx             !! Index
  character(len=1)    :: current
  character(len=1)    :: expected
  character(len=140)  :: line
  character(len=1)    :: opening(4)           = (/'(', '[', '{', '<'/)
  integer             :: syntax_score(4)      = (/3, 57, 1197, 25137/)
  integer             :: sum_syntax_score     = 0
  integer(kind = 8)  :: sum_completion_score = 0
  integer(kind = 8)  :: incompletes(100)
  logical             :: has_syntax_error
  !--------------------------------------------------------------------------

  ! opening the file for reading
  open(1, file = 'input.data', status = 'old', iostat=ios)
  if ( ios /= 0 ) stop "Error opening file."

  do
    read(1, *, iostat=ios) line
    if (ios /= 0) exit

    has_syntax_error = .false.
    line_loop: do i = 1,len(trim(line))
      current = line(i:i)
      idx = get_index(current)

      if ( idx == -1 ) then
        call s%push(current)
      else
        expected = opening(idx)
        current = s%peek()
        if (expected == current) then
          call s%pop()
          continue
        else
          sum_syntax_score = sum_syntax_score + syntax_score(idx)
          has_syntax_error = .true.
          exit line_loop
        endif
      endif
    end do line_loop

    if (has_syntax_error .neqv. .true.) then
      sum_completion_score = 0
      incomplete = incomplete + 1
      do while (s%is_empty() .neqv. .true.)
        current = s%peek()
        sum_completion_score = (sum_completion_score * 5) + get_completion_score(current)
        call s%pop()
      end do
      incompletes(incomplete) = sum_completion_score
    endif

    call s%clear()

  end do
  close(1)

  call sort(incompletes, incomplete)
  write(stdout, *) "First: ", sum_syntax_score
  write(stdout, *) "Second: ", incompletes(incomplete/2+1)

contains
  
  subroutine sort(arr, len)
    integer           :: len
    integer(kind = 8) :: arr(len)
    !---
    integer           :: i
    integer           :: j
    integer(kind = 8)           :: tmp

    do i = 1, len
      do j = 1, len
        if (arr(j) < arr(i)) then
          tmp = arr(i)
          arr(i) = arr(j)
          arr(j) = tmp
        endif
      end do
    end do
  end subroutine sort

  function get_index(c) result (return_value)
    character(len=1)  :: c
    integer           :: return_value

    if (c == ')') then
      return_value = 1
    elseif (c == ']') then
      return_value = 2
    elseif (c == '}') then
      return_value = 3
    elseif (c == '>') then
      return_value = 4
    else
      return_value = -1
    endif
  end function get_index

  function get_completion_score(c) result (return_value)
    character(len=1)  :: c
    integer           :: return_value

    if (c == '(') then
      return_value = 1
    elseif (c == '[') then
      return_value = 2
    elseif (c == '{') then
      return_value = 3
    elseif (c == '<') then
      return_value = 4
    else
      return_value = -1
    endif
  end function get_completion_score

end program main
