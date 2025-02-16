const express = require("express");
const path = require("path");
const session = require("express-session");
const {
  ensureOrganiserAuthenticated,
  ensureAdminAuthenticated,
  ensurePartispantAuthenticated,
  adminLogged,
  organiserLogged,
  partispantLogged,
} = require("./middleware/middleware");

const bcrypt = require("bcrypt");
const handleLogin = require("./routes/loginRoute");
const { insertEvents, fetchAllEvents } = require("./DB/db");

const app = express();
const port = 8050;

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));
app.use(express.static(path.join(__dirname, "public")));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Session Configuration
app.use(
  session({ 
    secret: "iam_iron_man",
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false, httpOnly: true, maxAge: 86400000 },
  })
);

app.get("/", (req, res) => {
  const pageData = {
    title: "Resourse managment System",
  };
  res.render("index.ejs", pageData);
});

app.get("/admin/login", adminLogged, (req, res) => {
  res.render("adminLogin", { style: undefined });
});

app.post("/admin/login", async (req, res) => {
  const { userName, password } = req.body;
  console.log(userName, password);
  if (userName && password) {
    await handleLogin(userName, password, "admin", async (result) => {
      if (result) {
        req.session.user = { userName, role: "admin" };
        return res.redirect("/admin/dashboard");
      } else {
        return res.render("adminLogin", { style: "border: 1px solid red;" });
      }
    });
  } else {
    return res.render("adminLogin", { style: "border: 1px solid red;" });
  }
});

app.get("/admin/dashboard", ensureAdminAuthenticated, async (req, res) => {
  try {
    res.render("adminDashboard");
  } catch (error) {
    console.error("Error fetching dashboard data:", error);
    res.status(500).send("An error occurred while loading the dashboard");
  }
});

// app.get("/partispant/login", partispantLogged, (req, res) => {
//   res.render("partispantLogin", { style: undefined });
// });

// app.post("/partispant/login", async (req, res) => {
//   const { userName, password } = req.body;
//   console.log(userName, password);
//   if (userName && password) {
//     await handleLogin(userName, password, "partispant", async (result) => {
//       if (result) {
//         req.session.user = { userName, role: "partispant" };
//         return res.redirect("/partispant/dashboard");
//       } else {
//         return res.render("partispantLogin", { style: "border: 1px solid red;" });
//       }
//     });
//   } else {
//     return res.render("partispantLogin", { style: "border: 1px solid red;" });
//   }
// });
// app.get("/partispant/dashboard", ensurePartispantAuthenticated, async (req, res) => {
//   const bookedDetails = await fetchBookedDetailsWithId(
//     req.session.user.userName
//   );
//   const formattedBookedDetails = await fetchAndFormatBooked(bookedDetails);
//   const pageData = {
//   };
//   console.log(pageData);

//   res.render("partispantDashboard", pageData);
// });
app.get("/organiser/login", organiserLogged, (req, res) => {
  res.render("organiserLogin", { style: undefined });
});

app.post("/organiser/login", async (req, res) => {
  const { userName, password } = req.body;
  console.log(userName, password);
  if (userName && password) {
    await handleLogin(userName, password, "organiser", async (result) => {
      if (result) {
        req.session.user = { userName, role: "organiser" };
        return res.redirect("/organiser/dashboard");
      } else {
        return res.render("organiserLogin", {
          style: "border: 1px solid red;",
        });
      }
    });
  } else {
    return res.render("organiserLogin", { style: "border: 1px solid red;" });
  }
});

app.get(
  "/organiser/dashboard",
  ensureOrganiserAuthenticated,
  async (req, res) => {
    res.render("organiserDashboard");
  }
);

/**
   {
  eventName: 'Nice event',
  eventType: 'Seminar',
  eventDate: '2025-01-11',
  eventDescription: 'summa tha ',
  childEvents: [
    {
      childEventName: 'quizz',
      childEventType: 'MCQ type',
      maxParticipants: 5,
      childEventDescription: 'Its a team event'
    },
    {
      childEventName: 'discussion',
      childEventType: 'non tech',
      maxParticipants: 10,
      childEventDescription: 'panel discuss'
    }
  ]
}
   */
app.post(
  "/organiser/newEvent",
  ensureOrganiserAuthenticated,
  async (req, res) => {
    try {
      const { eventName, eventType, eventDate, eventDescription, childEvents } =
        req.body;

      if (!eventName || !eventType || !eventDate) {
        return res.status(400).json({
          success: false,
          message: "Event name, type, and date are required.",
        });
      }

      if (childEvents && !Array.isArray(childEvents)) {
        return res.status(400).json({
          success: false,
          message: "Child events must be an array.",
        });
      }

      const result = await insertEvents(
        eventName,
        eventType,
        eventDate,
        req.session.user.userName,
        eventDescription,
        childEvents
      );
      console.log(result);

      if (result && result.affectedRows === 1) {
        return res.status(201).json({
          success: true,
          message: "Event created successfully.",
        });
      }

      return res.status(500).json({
        success: false,
        message: "Failed to insert event. Please try again.",
      });
    } catch (error) {
      console.error("Error inserting event:", error);

      if (error.code === "ER_DUP_ENTRY") {
        return res.status(400).json({
          success: false,
          message: "Event already exists.",
        });
      }

      return res.status(500).json({
        success: false,
        message: "Internal server error. Please contact support.",
      });
    }
  }
);

app.get("/partispant/login", partispantLogged, (req, res) => {
  res.render("partispantLogin", { style: undefined });
});

app.post("/partispant/login", async (req, res) => {
  const { userName, password } = req.body;
  console.log(userName, password);
  if (userName && password) {
    await handleLogin(userName, password, "partispant", async (result) => {
      if (result) {
        req.session.user = { userName, role: "partispant" };
        return res.redirect("/partispant/dashboard");
      } else {
        return res.render("partispantLogin", {
          style: "border: 1px solid red;",
        });
      }
    });
  } else {
    return res.render("partispantLogin", { style: "border: 1px solid red;" });
  }
});

app.get(
  "/partispant/dashboard",
  ensurePartispantAuthenticated,
  async (req, res) => {
    res.render("partispantDashboard", {
      events: await fetchAllEvents(),
    });
  }
);

app.post("/logout", (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      console.error("Error destroying session:", err);
      return res.status(500).json({ message: "Internal Server Error" });
    }
    res.clearCookie("connect.sid");
    res.redirect("/");
  });
});

app.listen(port, () => {
  console.log(`App listening on port http://localhost:${port}`);
});
