const express = require("express");
const { fetchStsInfo } = require("../DB/db");
const router = express.Router();

router.get("/profile", async (req, res) => {
  const user = req.session.user;
  
  console.log("this is user", user);

  if (user.role === "admin") {
    const stdInfos = await fetchStsInfo();
    res.status(200).json({
      message: "Welcome to Admin profile",
      stdData: stdInfos,  
    });
  } else if (user.role === "faculty") {
    res.status(200).json({
      message: "Welcome to your profile",
      user: "Faculty login",
    });
  } else if (user.role === "student") {
    res.status(200).json({
      message: "Welcome to your profile",
      user: "studnet login",
    });
  }
});

module.exports = router;
