# To be sourced by WIP scripts
#
# Prohibit WIP script from running without inspecting or modifying first!

# NOTE:
# I am trying a method - "code as documentation": write code (most of time,
# scripts) to document the procedure. The main show stopper of this approach
# was the prohibitable amount of work in actually debugging the script to make
# them work. However, throughout my own experience, unless I am intimately
# familiar with the topic, the script debugging is usually very hard and
# time-consuming, and worst of all we still have to modify the
# scripts the next time I need to do a similar thing, if, only a big if we
# actually need to do it again (roughly speaking, 80% of the documented process
# is not used again, in a sense documentation is like insurance.)
#
# But, writing code to automate is so AWESOME! That's why we invented the
# computer in the first place, isn't it?
#
# So here we are, I will just try to convert the documentation into code and
# comments and leave it so! Without any debugging! Next time when we need them,
# or read them again, I'll do it. Hopefully, the end result is a documentation
# that are more useful (if not more readable), and eventually *grows* into a
# script that works after many iterations. Well, at this early stage of trial,
# finger crossed.

echo "* ERROR: You are trying to run a WIP script!!! Read the code first! Exiting..."
exit 1
