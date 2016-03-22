package com.systex.bingo;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import at.technikum.mti.fancycoverflow.FancyCoverFlow;




public class IndexActivity extends Activity {

	
	
	
	private FancyCoverFlow fancyCoverFlow;

	Intent it;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(com.systex.bingo.R.layout.activity_index);

	

		this.fancyCoverFlow = (FancyCoverFlow) this
				.findViewById(com.systex.bingo.R.id.fancyCoverFlow);
		this.fancyCoverFlow.setAdapter(new FancyCoverFlowSampleAdapter(this));
		this.fancyCoverFlow.setUnselectedAlpha(1.0f);
		this.fancyCoverFlow.setUnselectedSaturation(0.0f);
		this.fancyCoverFlow.setUnselectedScale(0.5f);
		this.fancyCoverFlow.setMaxRotation(100);
		
		
		this.fancyCoverFlow.setScaleDownGravity(0.2f);
		this.fancyCoverFlow.setActionDistance(FancyCoverFlow.ACTION_DISTANCE_AUTO);

		this.fancyCoverFlow.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view,
					int position, long id) {

				switch (position) {
				case 0:

					it = new Intent(IndexActivity.this, SmallBingoActivity.class);
					startActivity(it);

					break;

				case 1:

					it = new Intent(IndexActivity.this, MediumBingoActivity.class);
					startActivity(it);

					break;

				case 2:

					it = new Intent(IndexActivity.this,BigBingoActivity.class);
					startActivity(it);

					break;
			

				default:
					break;
				}


			}

		});
	}



	
	@Override
	public void onBackPressed() {

		AlertDialog.Builder ab = new AlertDialog.Builder(IndexActivity.this);

		ab.setMessage(com.systex.bingo.R.string.exit);
		ab.setNegativeButton(android.R.string.no, null);
		ab.setPositiveButton(android.R.string.ok, new OnClickListener() {

			@Override
			public void onClick(DialogInterface dialog, int which) {

				finish();

			}
		});

		ab.show();

	}

}