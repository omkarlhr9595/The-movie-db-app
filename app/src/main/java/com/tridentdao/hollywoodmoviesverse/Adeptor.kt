package com.tridentdao.hollywoodmoviesverse

import android.graphics.drawable.Drawable
import android.text.Layout
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.TextView
import android.widget.Toast
import androidx.recyclerview.widget.RecyclerView
import com.airbnb.lottie.LottieAnimationView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.DataSource
import com.bumptech.glide.load.engine.GlideException
import com.bumptech.glide.request.RequestListener
import com.bumptech.glide.request.target.Target

class Adeptor(private val listener: MovieItemClicked) : RecyclerView.Adapter<Card>() {

    private val items: ArrayList<MovieList> = ArrayList()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): Card {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.card, parent, false)
        val viewHolder = Card(view)
        view.setOnClickListener {
            listener.onItemClicked(items[viewHolder.adapterPosition])
        }
        return viewHolder
    }

    override fun onBindViewHolder(holder: Card, position: Int) {



        val currentItem = items[position]
        var imageDrawable: Drawable? = null
        holder.name.text = currentItem.name
        holder.progressBar.visibility = View.VISIBLE
        var link = ""
        link = currentItem.poster
        val posterlink: String
        if (link == "") {
            posterlink =
                "https://images.unsplash.com/photo-1485846234645-a62644f84728?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=300&q=80"
        } else {
            posterlink = "https://image.tmdb.org/t/p/w1280/$link"
        }
        Glide.with(holder.itemView.context).asDrawable().load(posterlink).listener(object :
            RequestListener<Drawable> {
            override fun onLoadFailed(
                e: GlideException?,
                model: Any?,
                target: Target<Drawable>?,
                isFirstResource: Boolean
            ): Boolean {
                holder.progressBar.visibility = View.VISIBLE
                holder.poster.setImageResource(R.drawable.na)
                return false
            }

            override fun onResourceReady(
                resource: Drawable?,
                model: Any?,
                target: Target<Drawable>?,
                dataSource: DataSource?,
                isFirstResource: Boolean
            ): Boolean {
                if (resource != null) {

                    imageDrawable = resource

                }
                holder.progressBar.visibility = View.GONE
                return false
            }
        }).into(holder.poster)
    }

    override fun getItemCount(): Int {
        return items.size
    }

    fun updateList(updatedList: ArrayList<MovieList>) {
        items.clear()
        items.addAll(updatedList)

        notifyDataSetChanged()
    }
}

class Card(itemView: View) : RecyclerView.ViewHolder(itemView) {
    val poster: ImageView = itemView.findViewById(R.id.imageView)
    val name: TextView = itemView.findViewById(R.id.textView)
    val progressBar: LottieAnimationView = itemView.findViewById(R.id.progressBar)
}
