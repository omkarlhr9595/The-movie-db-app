package com.tridentdao.hollywoodmoviesverse

import android.app.Dialog
import android.graphics.Color
import android.os.Bundle
import android.view.View
import android.view.Window
import android.view.WindowManager
import android.view.animation.Animation
import android.view.animation.TranslateAnimation
import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.app.AppCompatDelegate
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.android.volley.Request
import com.android.volley.toolbox.JsonObjectRequest
import com.bumptech.glide.Glide
import kotlinx.android.synthetic.main.activity_main.*


class MainActivity : AppCompatActivity(), MovieItemClicked {
    private lateinit var mAdeptor: Adeptor
    private lateinit var mAdeptor2: Adeptor2
    private lateinit var mAdeptor3: Adeptor3
    private lateinit var anim: Animation

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)


        //this will remove night mode
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES)


        val recyclerView: RecyclerView = findViewById(R.id.recycle)
        val recyclerView2: RecyclerView = findViewById(R.id.recycle2)
        val recyclerView3: RecyclerView = findViewById(R.id.recycle3)


        val result: TextView = findViewById(R.id.textView3)
        result.visibility = View.GONE
        val close: ImageButton = findViewById(R.id.close)
        close.setOnClickListener {
            result.visibility = View.GONE
            close.visibility = View.GONE
            recyclerView2.visibility = View.GONE
        }
        close.visibility = View.GONE


        recyclerView.layoutManager =
            LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false)
        recyclerView2.layoutManager =
            LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false)
        recyclerView3.layoutManager =
            LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false)



        getData()
        getData2()

        mAdeptor = Adeptor(this)
        mAdeptor2 = Adeptor2(this)
        mAdeptor3 = Adeptor3(this)
        recyclerView.adapter = mAdeptor
        recyclerView2.adapter = mAdeptor2
        recyclerView3.adapter = mAdeptor3

        val search: SearchView = findViewById(R.id.search)

        search.setOnQueryTextListener(object : SearchView.OnQueryTextListener {
            // Override onQueryTextSubmit method
            // which is call
            // when submitquery is searched
            override fun onQueryTextSubmit(query: String): Boolean {
                // If the list contains the search query
                // than filter the adapter
                // using the filter method
                // with the query as its argument
//                -----------------
                val recyclerView: RecyclerView = findViewById(R.id.recycle2)
                recyclerView.visibility = View.VISIBLE
//                recyclerView.animate().yBy(-50F).withEndAction { recyclerView.animate().yBy(50F) }

                val result: TextView = findViewById(R.id.textView3)
                result.visibility = View.VISIBLE
//                result.animate().yBy(-50F).withEndAction { result.animate().yBy(50F) }


//                search.animate().yBy(-50F).withEndAction { search.animate().yBy(50F) }

                val close: ImageButton = findViewById(R.id.close)
                close.visibility = View.VISIBLE
//                close.animate().yBy(-50F).withEndAction { close.animate().yBy(50F) }

                val p1: ProgressBar = findViewById(R.id.p1)
                p1.visibility = View.VISIBLE

                var temp = ArrayList<MovieList>()
                mAdeptor2.updateList(temp)


                val scale = resources.displayMetrics.density
                val height = scale * 370

                p1.layoutParams.height = (scale * 50).toInt()
                p1.layoutParams.width = (scale * 50).toInt()

                recyclerView.layoutParams.height = height.toInt()


                val url =
                    "https://api.themoviedb.org/3/search/movie?api_key=YOUR_API_KEY&language=en-US&page=1&include_adult=false&query=$query"
                val jsonObjectRequest2 = JsonObjectRequest(
                    Request.Method.GET,
                    url, null,
                    {
                        val movieJasonArray = it.getJSONArray("results")
                        val movieArray = ArrayList<MovieList>()



                        for (i in 0 until movieJasonArray.length()) {

                            val movieJsonObject = movieJasonArray.getJSONObject(i)

                            var name: String
                            try {
                                name = movieJsonObject.getString("title")
                            } catch (e: Exception) {
                                name = "NULL"
                            }
                            var poster: String
                            try {
                                poster = movieJsonObject.getString("poster_path")
                            } catch (e: Exception) {
                                poster = "NULL"
                            }
                            var desc: String
                            try {
                                desc = movieJsonObject.getString("overview")
                            } catch (e: Exception) {
                                desc = "NULL"
                            }
                            var date: String
                            try {
                                date = movieJsonObject.getString("release_date")
                            } catch (e: Exception) {
                                date = "NULL"
                            }
                            var rate: String
                            try {
                                rate = movieJsonObject.getString("vote_average")
                            } catch (e: Exception) {
                                rate = "NULL"
                            }

                            val movie = MovieList(
                                name,
                                poster,
                                desc,
                                date,
                                rate
                            )
                            movieArray.add(movie)
                        }
                        p1.visibility = View.GONE
                        mAdeptor2.updateList(movieArray)

                    },
                    {
                        Toast.makeText(
                            this@MainActivity,
                            "${it.networkResponse}",
                            Toast.LENGTH_LONG
                        ).show()
                    }
                )
                MySingleton.getInstance(this@MainActivity).addToRequestQueue(jsonObjectRequest2)


//                -----------------
                return false
            }

            // This method is overridden to filter
            // the adapter according to a search query
            // when the user is typing search
            override fun onQueryTextChange(newText: String): Boolean {

                return false
            }
        })


    }

    fun getData() {

        val p2: ProgressBar = findViewById(R.id.p2)
        p2.visibility = View.VISIBLE

        val url =
            "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=18bbc44d1e9834345fa7cd8f22c77cee&page=1"
        val jsonObjectRequest1 = JsonObjectRequest(
            Request.Method.GET,
            url, null,
            {
                val movieJasonArray = it.getJSONArray("results")
                val movieArray = ArrayList<MovieList>()
                for (i in 0 until movieJasonArray.length()) {
                    val movieJsonObject = movieJasonArray.getJSONObject(i)

                    var name: String
                    try {
                        name = movieJsonObject.getString("title")
                    } catch (e: Exception) {
                        name = "NULL"
                    }
                    var poster: String
                    try {
                        poster = movieJsonObject.getString("poster_path")
                    } catch (e: Exception) {
                        poster = "NULL"
                    }
                    var desc: String
                    try {
                        desc = movieJsonObject.getString("overview")
                    } catch (e: Exception) {
                        desc = "NULL"
                    }
                    var date: String
                    try {
                        date = movieJsonObject.getString("release_date")
                    } catch (e: Exception) {
                        date = "NULL"
                    }
                    var rate: String
                    try {
                        rate = movieJsonObject.getString("vote_average")
                    } catch (e: Exception) {
                        rate = "NULL"
                    }

                    val movie = MovieList(
                        name,
                        poster,
                        desc,
                        date,
                        rate
                    )
                    movieArray.add(movie)
                }
                p2.visibility = View.GONE
                mAdeptor.updateList(movieArray)

            },
            {

            }
        )
        MySingleton.getInstance(this).addToRequestQueue(jsonObjectRequest1)
    }

    fun getData2() {

        val p3: ProgressBar = findViewById(R.id.p3)
        p3.visibility = View.VISIBLE

        val url =
            "https://api.themoviedb.org/3/discover/tv?sort_by=popularity.desc&api_key=18bbc44d1e9834345fa7cd8f22c77cee&page=1"
        val jsonObjectRequest3 = JsonObjectRequest(
            Request.Method.GET,
            url, null,
            {
                val movieJasonArray = it.getJSONArray("results")
                val movieArray = ArrayList<MovieList>()
                for (i in 0 until movieJasonArray.length()) {
                    val movieJsonObject = movieJasonArray.getJSONObject(i)

                    var name: String
                    try {
                        name = movieJsonObject.getString("name")
                    } catch (e: Exception) {
                        name = "NULL"
                    }
                    var poster: String
                    try {
                        poster = movieJsonObject.getString("poster_path")
                    } catch (e: Exception) {
                        poster = "NULL"
                    }
                    var desc: String
                    try {
                        desc = movieJsonObject.getString("overview")
                    } catch (e: Exception) {
                        desc = "NULL"
                    }
                    var date: String
                    try {
                        date = movieJsonObject.getString("first_air_date")
                    } catch (e: Exception) {
                        date = "NULL"
                    }
                    var rate: String
                    try {
                        rate = movieJsonObject.getString("vote_average")
                    } catch (e: Exception) {
                        rate = "NULL"
                    }

                    val movie = MovieList(
                        name,
                        poster,
                        desc,
                        date,
                        rate
                    )
                    movieArray.add(movie)
                }

                p3.visibility = View.GONE
                mAdeptor3.updateList(movieArray)

            },
            {

            }
        )
        MySingleton.getInstance(this).addToRequestQueue(jsonObjectRequest3)
    }


    override fun onItemClicked(item: MovieList) {
//        Toast.makeText(this,"${item.name} is Clicked",Toast.LENGTH_SHORT).show()
        val searchView:SearchView = findViewById(R.id.search)
        val t1:TextView = findViewById(R.id.textView3)
        val t2:TextView = findViewById(R.id.textView4)
        val t3:TextView = findViewById(R.id.textView2)
        val close:ImageButton = findViewById(R.id.close)
        val recyclerView1 = findViewById<RecyclerView>(R.id.recycle)
        val recyclerView2 = findViewById<RecyclerView>(R.id.recycle2)
        val recyclerView3 = findViewById<RecyclerView>(R.id.recycle3)

//        searchView.animate().yBy(-50F).withEndAction { searchView.animate().yBy(50F) }
//        t1.animate().yBy(-50F).withEndAction { t1.animate().yBy(50F) }
//        t2.animate().yBy(-50F).withEndAction { t2.animate().yBy(50F) }
//        t3.animate().yBy(-50F).withEndAction { t3.animate().yBy(50F) }
//        close.animate().yBy(-50F).withEndAction { close.animate().yBy(50F) }
//        recyclerView1.animate().yBy(-50F).withEndAction { recyclerView1.animate().yBy(50F) }
//        recyclerView2.animate().yBy(-50F).withEndAction { recyclerView2.animate().yBy(50F) }
//        recyclerView3.animate().yBy(-50F).withEndAction { recyclerView3.animate().yBy(50F) }
        showdialog(item.name, item.poster, item.desciption, item.date, item.rate)
    }

    fun showdialog(name: String, poster: String, description: String, date: String, rate: String) {
        var dialog1 = Dialog(this)
        dialog1.requestWindowFeature(Window.FEATURE_NO_TITLE)
        dialog1.setContentView(R.layout.dialog_box)
        dialog1.setCancelable(true)



        var title = dialog1.findViewById<TextView>(R.id.movietitle)
        title.setText(name)

        var this_date = dialog1.findViewById<TextView>(R.id.date)
        this_date.setText(date)

        var this_rate = dialog1.findViewById<TextView>(R.id.rate)

        var condition = rate.toDouble()
        if (condition >= 7 && condition <= 10) {
            this_rate.setTextColor(Color.parseColor("#4CAF50"))
        } else if (condition >= 5 && condition < 7) {
            this_rate.setTextColor(Color.parseColor("#FFD740"))
        } else {
            this_rate.setTextColor(Color.parseColor("#F44336"))
        }

        this_rate.setText(rate)


        var desc = dialog1.findViewById<TextView>(R.id.desc)
        desc.setText("\t\t\t\t$description")

        var thisposter = dialog1.findViewById<ImageView>(R.id.posterimg)
        Glide.with(this).load("https://image.tmdb.org/t/p/w1280/$poster").into(thisposter)

        var close = dialog1.findViewById<ImageButton>(R.id.close)
        close.setOnClickListener(View.OnClickListener {
            dialog1.dismiss()
        })

        val lp = WindowManager.LayoutParams()
        lp.copyFrom(dialog1.window!!.attributes)
        lp.width = WindowManager.LayoutParams.WRAP_CONTENT
        lp.height = WindowManager.LayoutParams.WRAP_CONTENT

        dialog1.show()
        dialog1.getWindow()!!.setAttributes(lp)
    }
}
