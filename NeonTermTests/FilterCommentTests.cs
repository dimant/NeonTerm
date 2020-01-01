using Microsoft.VisualStudio.TestTools.UnitTesting;
using NeonTerm;

namespace NeonTermTests
{
    [TestClass]
    public class FilterCommentTests
    {
        [TestMethod]
        public void Filter_Brace_ShouldFilter()
        {
            var filter = new FilterComment();

            Assert.IsFalse(filter.Filter('('), "opening brace should not be filtered");
            Assert.IsFalse(filter.Filter(' '), "space after opening brace should not be filtered");
            Assert.IsTrue(filter.Filter('x'), "char in comment should be filtered");
        }

        [TestMethod]
        public void Filter_Brace_ShouldTerminateWithBrace()
        {
            var filter = new FilterComment();

            Assert.IsFalse(filter.Filter('('), "opening brace should not be filtered");
            Assert.IsFalse(filter.Filter(' '), "space after opening brace should not be filtered");
            Assert.IsTrue(filter.Filter('x'), "char in comment should be filtered");
            Assert.IsFalse(filter.Filter(')'), "closing brace comment should not be filtered");
        }

        [TestMethod]
        public void Filter_Brace_ShouldTerminateWithNewLine()
        {
            var filter = new FilterComment();

            Assert.IsFalse(filter.Filter('('), "opening brace should not be filtered");
            Assert.IsFalse(filter.Filter(' '), "space after opening brace should not be filtered");
            Assert.IsTrue(filter.Filter('x'), "char in comment should be filtered");
            Assert.IsFalse(filter.Filter('\n'), "newline char should not be filtered");
        }

        [TestMethod]
        public void Filter_Slash_ShouldFilter()
        {
            var filter = new FilterComment();

            Assert.IsFalse(filter.Filter('\\'), "slash should not be filtered");
            Assert.IsFalse(filter.Filter(' '), "space after slash should not be filtered");
            Assert.IsTrue(filter.Filter('x'), "char in comment should be filtered");
        }

        [TestMethod]
        public void Filter_Slash_ShouldTerminateWithNewLine()
        {
            var filter = new FilterComment();

            Assert.IsFalse(filter.Filter('\\'), "slash should not be filtered");
            Assert.IsFalse(filter.Filter(' '), "space after slash should not be filtered");
            Assert.IsTrue(filter.Filter('x'), "char in comment should be filtered");
            Assert.IsFalse(filter.Filter('\n'), "newline char in comment should not be filtered");
        }

        [TestMethod]

        public void Filter_Code_ShouldNotFilter()
        {
            var code = ": '(enter) ] ' (enter) [ LITERAL ;";
            var filter = new FilterComment();

            foreach(var c in code)
            {
                Assert.IsFalse(filter.Filter(c), $"Char '{c}' should not be filtered.");
            }
        }
    }
}
