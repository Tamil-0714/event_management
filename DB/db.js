const mysql = require("mysql2");

const pool = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "TooJoo_1967",
  database: "event_mangement",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

async function queryDB(sql, params) {
  const connection = await pool.promise().getConnection(); // Get a connection from the pool
  try {
    const [rows] = await connection.query(sql, params);
    return rows;
  } catch (error) {
    throw error;
  } finally {
    connection.release(); // Release the connection back to the pool
  }
}

async function fetchCred(id, flag) {
  try {
    let query;
    switch (flag) {
      case "admin":
        query = "SELECT * FROM admin WHERE id = ?";
        break;
      case "organiser":
        query = "SELECT * FROM organiser WHERE organiser_id = ?";
        break;
      case "partispant":
        query = "SELECT * FROM partispants WHERE partispant_id = ?";
        break;
    }
    const params = [id];
    const rows = await queryDB(query, params);
    console.log("this is rows : ", rows);

    return rows;
  } catch (error) {
    console.error(error);
    throw error;
  }
}

/*
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
async function insertEvents(
  eventName,
  eventType,
  eventDate,
  organiserId,
  eventDescription,
  childEvents
) {
  try {
    const query =
      "INSERT INTO parent_event (event_name, event_type, event_date, organiser_id, description) VALUES (?, ?, ?, ?, ?)";
    const params = [
      eventName,
      eventType,
      eventDate,
      organiserId,
      eventDescription,
    ];
    const result = await queryDB(query, params);
    const eventId = result.insertId;
    let rows;
    if (eventId) {
      for (let i = 0; i < childEvents.length; i++) {
        const cEvent = childEvents[i];
        const query =
          "INSERT INTO child_event (child_event_name, child_event_type, max_partispant, event_id, description) VALUES (?, ?, ?, ?, ?)";
        const params = [
          cEvent.childEventName,
          cEvent.childEventType,
          cEvent.maxParticipants,
          eventId,
          cEvent.childEventDescription,
        ];
        rows = await queryDB(query, params);
      }
      return rows;
    }
  } catch (error) {
    console.error(error);
    throw error;
  }
}

async function fetchAllEvents() {
  try {
    const query = "SELECT * FROM parent_event";
    const params = [];
    return await queryDB(query, params);
  } catch (error) {
    console.error(error);
  }
}

async function fetchAllEnrollments() {
  try {
    const query = `SELECT 
    e.enroll_id,
    p.partispant_name,
    ev.event_name,
    e.enrolled_time
FROM event_enrolments e
JOIN partispants p ON e.partispant_id = p.partispant_id
JOIN parent_event ev ON e.event_id = ev.event_id;
`;
    const params = [];
    return await queryDB(query, params);
  } catch (error) {}
}
async function enrollEvent(eventId, userId) {
  try {
    const query =
      "INSERT INTO `event_enrolments` (`enroll_id`, `partispant_id`, `event_id`, `enrolled_time`) VALUES (NULL, ?, ?, CURRENT_TIMESTAMP)";
    const params = [userId, eventId];
    return await queryDB(query, params);
  } catch (error) {
    console.error(error);
    throw error;
  }
}

module.exports = {
  fetchCred,
  insertEvents,
  fetchAllEvents,
  enrollEvent,
  fetchAllEnrollments,  
};
